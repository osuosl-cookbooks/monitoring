#
# Cookbook Name:: monitoring
# Recipe:: default
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

# Check for high load.  This check defines warning levels and attributes
check_load = node['monitoring']['check_load']
nagios_nrpecheck "check_load" do
  command "#{node['nagios']['plugin_dir']}/check_load"
  warning_condition check_load['warning']
  critical_condition check_load['critical']
  action :add
end

# Check all non-NFS/tmp-fs disks.
check_all_disks = node['monitoring']['check_all_disks']
nagios_nrpecheck "check_all_disks" do
  command "#{node['nagios']['plugin_dir']}/check_disk"
  warning_condition check_all_disks['warning']
  critical_condition check_all_disks['critical']
  parameters check_all_disks['parameters']
  action :add
end

# Check for excessive users.  This command relies on the service definition to
# define what the warning/critical levels and attributes are
nagios_nrpecheck "check_users" do
  command "#{node['nagios']['plugin_dir']}/check_users"
  action :remove
end

# Check for swap usage
check_swap = node['monitoring']['check_swap']
nagios_nrpecheck "check_swap" do
  command "#{node['nagios']['plugin_dir']}/check_swap"
  warning_condition check_swap['warning']
  critical_condition check_swap['critical']
  action :add
end
