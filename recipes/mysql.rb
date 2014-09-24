#
# Cookbook Name:: monitoring
# Recipe:: mysql
#
# Copyright (C) 2013, Oregon State University
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
include_recipe "nagios::client_package"
include_recipe "nagios::client"

# Add defaults file for mysql nagios checks
template "#{node['nagios']['nrpe']['conf_dir']}/mysql.cnf" do
  source "mysql.cnf.erb"
  mode 0600
  owner node['nagios']['user']
  group node['nagios']['group']
end

%w[processlist innodb pidfile replication-delay].each do |c|
  nagios_nrpecheck "pmp-check-mysql-#{c}" do
    command "#{node['nagios']['plugin_dir']}/pmp-check-mysql-#{c}"
    action :add
  end
end
