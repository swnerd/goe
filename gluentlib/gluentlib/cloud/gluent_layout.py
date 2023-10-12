#! /usr/bin/env python3
""" gluent_layout: Representation of Gluent 'HDFS tree' layout
    
    LICENSE_TEXT
"""

import datetime
import logging
import re

###############################################################################
# EXCEPTIONS
###############################################################################
class GluentLayoutException(Exception): pass


###############################################################################
# CONSTANTS
###############################################################################

# Expected length of 'timestamp' in 'gluent timestamp' column
TS_EXPECTED_LENGTH = {
   'd': 10,
   'm': 7,
   'y': 4
}

# Regex to parse 'gluent timestamp' column
TS_REGEX=re.compile('gl_part_(m|d|y)_time_id=([^/]+)')

# Regex to parse 'partitions'
PARTITION_REGEX=re.compile('^(\S+)=(\S+)$')


###############################################################################
# LOGGING
###############################################################################
logger = logging.getLogger(__name__)
logger.addHandler(logging.NullHandler()) # Disabling logging by default


class GluentHdfsLayout(object):
    """ MIXIN: GluentHdfsLayout: Representation of gluent hive/impala 'file tree'

        Specifically, provides primitives to parse/search 'gluent timestamp' columns
    """
    __slots__ = () # No internal data


    ###########################################################################
    # PUBLIC ROUTINES
    ###########################################################################

    def add_partitions(self, data, file_key):
        """ Parse 'partition key/values' and add them to 'data'
            if possible
        """

        partitions = self.extract_partitions(file_key)
        if partitions:
            data['partitions'] = partitions

        return data


    def extract_partitions(self, file_key):
        """ Extract 'hive partitions' from 'file_key' string

            Partitions are /key=value/ chunks in the string
        """
        partitions = []

        for chunk in file_key.split('/'):
            partition_match = PARTITION_REGEX.match(chunk)
            if partition_match:
                key, value = partition_match.groups()
                if value.isdigit():
                    value = int(value)
                partitions.append((key, value))

        return partitions


    def add_gluentts(self, data, file_key):
        """ Parse 'gluent timestamp' and add 'timestamp' key/value pair to 'data'
            if possible
        """

        gluent_ts = self.extract_gluentts(file_key)
        if gluent_ts is not None:
            data['timestamp'] = gluent_ts

        return data


    def extract_gluentts(self, file_key, missing_value=99999999):
        """ Extract 'gluent timestamp' from a 'file key' and return as a number

            I.e.:
            offload_bucket_id=9/gl_part_m_time_id=2015-06/data.0.parq -> 20150600
            offload_bucket_id=9/gl_part_y_time_id=2015/data.0.parq -> 20150000
            offload_bucket_id=9/gl_part_d_time_id=2015-06-01/data.0.parq -> 20150601

            If no 'gluent timestamp' columns, return 'missing_value'
            offload_bucket_id=9/data.0.parq -> 99999999 (default)

            Missing value is: max(): 99999999 by default, on the assumption that
            we want to copy the entire table in such case (i.e. such tables are 'small')
        """
        assert file_key
        
        match = TS_REGEX.search(file_key)
        if match:
            ts_resolution, ts = match.group(1), match.group(2)
          
            # Basic timestamp validation
            if len(ts) != TS_EXPECTED_LENGTH[ts_resolution]:
                logger.warn("Invalid timestamp: %s detected for: '%s' granularity." % \
                    (ts, ts_resolution))
       
                return None

            ts_number = int(ts.replace('-', ''))
            if 'y' == ts_resolution:
                ts_number *= 10000
            elif 'm' == ts_resolution:
                ts_number *= 100

            logger.debug("Detected 'gluent timestamp': %s.%s in file key: %s. Extracting timestamp: %d" % \
                (ts_resolution, ts, file_key, ts_number))
            return ts_number
        else:
            logger.debug("Did not detect 'gluent' timestamp in file key: %s. Assigning default: %d" % \
                (file_key, missing_value))
            return missing_value


###############################################################################
# STANDALONE ROUTINES
###############################################################################

def datestr_to_gluentts(date_str, date_format='%Y-%m-%d'):
    """ Convert date string (with format) into 'gluent timestamp'

        i.e. '2015-01-15' to 20150115
    """

    ts = datetime.datetime.strptime(date_str, date_format)
    timestamp = ts.year * 10000 + ts.month * 100 + ts.day

    return timestamp
