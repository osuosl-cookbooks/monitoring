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

if node['monitoring']['check_raid']
  include_recipe 'base::oslrepo' # Required to install `hpacucli` package
  include_recipe 'nagios::client_package'
  include_recipe 'nagios::client'

  # NRPE plugins, parameters, and required packages
  plugininfo = {
    'aac' => {
      'plugin' => 'check-aacraid.py',
      'parameters' => '2>/dev/null',
      'packages' => []
    },
    'hp' => {
      'plugin' => 'check_hpacucli',
      'parameters' => '-t',
      'packages' => ['hpacucli']
    },
    'megaraid' => {
      'plugin' => 'check_megaraid_sas',
      'parameters' => '-b -o 100 -m 1000',
      'packages' => ['megacli']
    },
    'megaraid-nobbu' => {
      'plugin' => 'check_megaraid_sas',
      'parameters' => '-o 100 -m 1000',
      'packages' => ['megacli']
    },
    'mpt' => {
      'plugin' => 'check_mpt',
      'parameters' => '',
      'packages' => ['mptstatus']
    },
    'md' => {
      'plugin' => 'check_linux_raid',
      'parameters' => '',
      'packages' => ['nagios-plugins-linux_raid']
    }
  }

  # Try and detect the RAID check type automatically
  raidtype = case
  when node['kernel']['modules'].key?('aacraid')
    'aac'
  when node['kernel']['modules'].key?('megaraid_sas')
    'megaraid'
  when node['kernel']['modules'].key?('cciss')
    'hp'
  when node['kernel']['modules'].key?('mptctl')
    'mpt'
  when node.key?('mdadm')
    'md'
  end

  if raidtype.nil?
    # Don't do anything if we still don't have a RAID type
    Chef::Log.warn("Could not detect RAID check type; not creating any Nagios RAID checks.")
  else
    Chef::Log.info("Creating Nagios RAID checks of type '#{raidtype}'.")

    plugin = plugininfo[raidtype]['plugin']
    parameters = plugininfo[raidtype]['parameters']
    packages = plugininfo[raidtype]['packages']

    # Install required packages
    packages.each do |p|
      package p
    end

    # Install nrpe plugin
    pluginpath = File.join('files', 'default', 'nagios', 'plugins', plugin)
    cookbook_file File.join(node['nagios']['plugin_dir'], plugin) do
      source pluginpath
      mode '775'
      only_if { run_context.has_cookbook_file_in_cookbook?(cookbook_name, pluginpath) }
    end

    # Create nrpe check
    nagios_nrpecheck "check_raid_#{raidtype}" do
      command File.join(node['nagios']['plugin_dir'], plugin)
      parameters parameters
    end
  end
end
