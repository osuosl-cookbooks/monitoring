#
# Cookbook Name:: monitoring
# Recipe:: http
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

package "nagios-plugins-http" do
  action :install
end

# Check http
nagios_nrpecheck "check_http" do
  command "#{node['nagios']['plugin_dir']}/check_http"
  parameters "-H #{node['monitoring']['check_vhost']['server_name']} -I #{node['monitoring']['check_vhost']['ipaddress']}"
  action :add
end


