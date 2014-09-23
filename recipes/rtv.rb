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
include_recipe "osl-munin::client"

nagios_nrpecheck "check_rocky_worker" do
  command "#{node['nagios']['plugin_dir']}/check_procs"
  critical_condition node['monitoring']['check_rocky_worker']['critical']
  parameters node['monitoring']['check_rocky_worker']['parameters']
  action :add
end

secrets = Chef::EncryptedDataBagItem.load(node['proj-rtv']['data_bag'], "secrets")

template "#{node['munin']['basedir']}/plugin-conf.d/pdf_queue" do
  source "munin/pdf_queue.erb"
  owner  "munin"
  group "root"
  variables( :secrets => secrets )
  mode "0600"
end

cookbook_file "#{node['munin']['plugin_dir']}/pdf_queue" do
  source "munin/pdf_queue"
  owner  "root"
  group "root"
  mode "0600"
end

munin_plugin 'pdf_queue'
