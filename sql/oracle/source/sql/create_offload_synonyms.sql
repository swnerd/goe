/*
# Copyright 2016 The GOE Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/

SET SERVEROUTPUT ON

DECLARE

    c_owner        CONSTANT VARCHAR2(128) := SYS_CONTEXT('userenv', 'current_schema');
    c_adm_schema   CONSTANT VARCHAR2(128) := '&goe_db_adm_user';
    c_app_schema   CONSTANT VARCHAR2(128) := '&goe_db_app_user';
    c_repo_schema  CONSTANT VARCHAR2(128) := '&goe_db_repo_user';

    TYPE args_ntt IS TABLE OF VARCHAR2(130);

    PROCEDURE exec_sql ( p_sql  IN VARCHAR2,
                         p_args IN args_ntt DEFAULT NULL ) IS
        v_sql VARCHAR2(32767) := p_sql;
    BEGIN
        FOR i IN 1 .. p_args.COUNT LOOP
            v_sql := REPLACE(v_sql, '%'||i, p_args(i));
        END LOOP;
        EXECUTE IMMEDIATE v_sql;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error executing SQL : ' || v_sql);
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RAISE;
    END exec_sql;

BEGIN

    -- Synonyms for GOE ADM objects in GOE APP schema...
    FOR r IN ( SELECT o.owner
               ,      o.object_name
               ,      o.object_type
               FROM   dba_objects o
               WHERE  o.owner = c_owner
               AND    o.object_type IN ('TYPE','PACKAGE','FUNCTION','PROCEDURE','VIEW')
               ORDER  BY
                      o.object_type
               ,      o.object_name )
    LOOP
        exec_sql( p_sql  => 'CREATE OR REPLACE SYNONYM %1.%2 FOR %3.%4',
                  p_args => args_ntt(c_app_schema,
                                     r.object_name,
                                     r.owner,
                                     r.object_name) );
    END LOOP;

END;
/
