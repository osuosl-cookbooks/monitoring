#
# Cookbook Name:: monitoring
# Recipe:: rtv
#
# Copyright (C) 2014, Oregon State University
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
nagios_nrpecheck "check_rocky_worker" do
  command "#{node['nagios']['plugin_dir']}/check_procs"
  critical_condition node['nagios']['check_rocky_worker']['critical']
  parameters node['nagios']['check_rocky_worker']['parameters']
  action :add
end
