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
include_recipe 'nagios::client_package'
include_recipe 'nagios::client'

# NRPE plugins, parameters, and required packages
plugininfo = {}
plugininfo['aac'] = {
  'plugin' => 'check-aacraid.py',
  'parameters' => '2>/dev/null',
  'packages' => []
}
plugininfo['hp'] = {
  'plugin' => 'check_hpacucli',
  'parameters' => '-t',
  'packages' => ['hpacucli']
}
plugininfo['lsiutil'] = {
  'plugin' => 'check_lsiutil',
  'parameters' => '',
  'packages' => ['lsiutil']
}
plugininfo['megaraid'] = {
  'plugin' => 'check_megaraid_sas',
  'parameters' => '-b -o 100i -m 1000',
  'packages' => ['megacli']
}
plugininfo['megaraid-nobbu'] = {
  'plugin' => 'check_megaraid_sas',
  'parameters' => '-o 100 -m 1000',
  'packages' => ['megacli']
}
plugininfo['megarc'] = {
  'plugin' => 'check_megarc',
  'parameters' => '',
  'packages' => ['megarc']
}
plugininfo['mpt'] = {
  'plugin' => 'check_mpt',
  'parameters' => '',
  'packages' => ['mptstatus']
}
plugininfo['md'] = {
  'plugin' => 'check_linux_raid',
  'parameters' => '',
  'packages' => ['nagios-plugins-linux_raid']
}

# By default, RAID type is specified manually through an attribute
if plugininfo.key? node['monitoring'].fetch('raid-type', nil)
  raidtype = node['monitoring']['raid-type']
end

# If RAID type not set, try and detect it automatically
if raidtype.nil?
  if node['kernel']['modules'].key? 'aacraid'
    raidtype = 'aac'
  elsif node['kernel']['modules'].key? 'megaraid_sas'
    raidtype = 'megaraid'
  elsif node['kernel']['modules'].key? 'cciss'
    raidtype = 'hp'
  elsif node['kernel']['modules'].key? 'mptctl'
    raidtype = 'mpt'
  elsif `lspci` =~ /SCSI storage controller: LSI/ != nil
    raidtype = 'lsiutil'
  elsif `lspci` =~ /RAID bus controller: Dell/ != nil
    raidtype = 'megarc'
  end
end

# Don't do anything if we still don't have a RAID type
unless raidtype.nil?
  plugin = plugininfo[raidtype]['plugin']
  parameters = plugininfo[raidtype]['parameters']
  packages = plugininfo[raidtype]['packages']

  # Install required packages
  packages.each do |p|
    package p
  end

  # Install nrpe plugin
  cookbook_file File.join(node['nagios']['plugin_dir'], plugin) do
    source File.join('nagios', 'plugins', plugin)
    mode '775'
    action :create
  end

  # Create nrpe check
  nagios_nrpecheck "check_raid_#{raidtype}" do
    command "#{node['nagios']['plugin_dir']}/#{plugin}"
    parameters parameters
    action :add
  end
end
