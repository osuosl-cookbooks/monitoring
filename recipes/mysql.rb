#
# Cookbook Name:: monitoring
# Recipe:: mysql
#
# Copyright (C) 2013, OSU Open Source Lab
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Add defaults file for mysql nagios checks
template "#{node['nagios']['nrpe']['conf_dir']}/mysql.cnf" do
  source "mysql.cnf.erb"
  mode "600"
  owner "#{node['nagios']['user']}"
  group "#{node['nagios']['group']}"
end

# Check mysql processlist 
nagios_nrpecheck "pmp-check-mysql-processlist" do
  command "#{node['nagios']['plugin_dir']}/pmp-check-mysql-processlist"
  action :add
end

# Check mysql problems inside innodb 
nagios_nrpecheck "pmp-check-mysql-innodb" do
  command "#{node['nagios']['plugin_dir']}/pmp-check-mysql-innodb"
  action :add
end

# Check for mysql pidfile
nagios_nrpecheck "pmp-check-mysql-pidfile" do
  command "#{node['nagios']['plugin_dir']}/pmp-check-mysql-pidfile"
  action :add
end

# Check replication
nagios_nrpecheck "pmp-check-mysql-replication-delay" do
  command "#{node['nagios']['plugin_dir']}/pmp-check-mysql-replication-delay"
  action :add
end

