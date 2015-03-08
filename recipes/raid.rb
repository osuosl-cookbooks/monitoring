#
# Cookbook Name:: monitoring
# Recipe:: raid
#
# Copyright (C) 2015, Oregon State University
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

# Get RAID type and set nrpe plugin name
case node['monitoring']['raid-type']
  when 'aac'
    plugin = "check-aacraid.py"
    parameters = "2>/dev/null"
  when 'hp'
    plugin = "check_hpacucli"
    parameters = "-t"
  when 'lsi'
    plugin = "check_lsiutil"
    parameters = ""
  when 'megaraid'
    plugin = "check_megaraid_sas"
    parameters = "-b -o 100i -m 1000"
  when 'megaraid-nobbu'
    plugin = "check_megaraid_sas"
    parameters = "-o 100 -m 1000"
  when 'megarc'
    plugin = "check_megarc"
    parameters = ""
  when 'mpt'
    plugin = "check_mpt"
    parameters = ""
  when 'md'
    plugin = "md"
    parameters = ""
end

# Install nrpe plugin
if plugin == "md"
  package "nagios-plugins-linux_raid"
else
  cookbook_file File.join(node['nagios']['plugin_dir'], plugin) do
    source File.join('nagios', 'plugins', plugin)
    mode '775'
    action :create
  end
end

# Create nrpe check
check_vhost = node['monitoring']['check_vhost']
nagios_nrpecheck plugin do
  command "#{node['nagios']['plugin_dir']}/#{plugin}"
  parameters parameters
  action :add
end
