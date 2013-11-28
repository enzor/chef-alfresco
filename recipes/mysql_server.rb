#
# Cookbook Name:: alfresco
# Recipe:: mysql_server
#
# Copyright 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

### Include Recipe Dependencies
include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "database::mysql"

db_database = node['alfresco']['db']['database']
db_port     = node['alfresco']['db']['port']
db_user     = node['alfresco']['db']['user']
db_pass     = node['alfresco']['db']['password']

db_info = {
  :host     => node['mysql']['bind_address'],
  :port     => db_port,
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

### Create Mysql Database Instance And Application User
mysql_database db_database do
  connection  db_info
end

mysql_database_user "#{node['alfresco']['db']['user']}" do
  connection      db_info
  database_name   db_database
  password        db_pass
  privileges      [ :all ]
  host            node['alfresco']['db']['repo_host']
  action          :grant
  notifies        :restart, "service[mysql]", :immediately
end