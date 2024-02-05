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

@@sql/store_sqlplus_env.sql
set verify off

prompt
prompt ================================================================================
prompt Upgrading GOE...
prompt ================================================================================
prompt

@@sql/upgrade_env.sql
@@sql/check_offload_install.sql
@@sql/create_offload_privs.sql
@@sql/drop_offload_obsolete_objects.sql
alter session set current_schema = &goe_db_adm_user;
@@sql/drop_offload_code.sql
@@sql/install_offload_code.sql
@@sql/create_offload_repo.sql
@@sql/upgrade_goe_version.sql

prompt
prompt ================================================================================
prompt GOE successfully upgraded.
prompt ================================================================================
prompt

@@sql/check_goe_user_expiration.sql
@@sql/restore_sqlplus_env.sql
