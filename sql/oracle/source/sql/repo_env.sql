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

whenever sqlerror exit failure
whenever oserror exit failure

undefine goe_repo_install
undefine goe_repo_upgrade

col goe_repo_upgrade new_value goe_repo_upgrade
col goe_repo_install new_value goe_repo_install
select decode(count(*), 0, 'Y', 'N') as goe_repo_install
     , decode(count(*), 0, 'N', 'Y') as goe_repo_upgrade
  from dba_tables
 where owner = '&goe_db_repo_user';

spool sql/repo_env.tmp replace
set serveroutput on feedback off lines 200
begin
    dbms_output.put_line(q'{-- Script generated by repo_env.sql}');
    dbms_output.put_line(q'{-- Copyright ' || to_char(sysdate, 'YYYY') || ' The GOE Authors. All rights reserved.}');
    dbms_output.put_line(q'{--}');
    if '&goe_repo_install' = 'Y' then
        dbms_output.put_line('@@install_repo_env.sql');
    else
        dbms_output.put_line('@@upgrade_repo_env.sql');
    end if;
end;
/
spool off

@@repo_env.tmp
