#
# Cookbook Name:: monitoring
# Recipe:: apache
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
include_recipe "osl-munin::client"
include_recipe "apache2::mod_status"

package "perl-Crypt-SSLeay" do
    action :install
end

node.override["apache"]["ext_status"] = true

template "/etc/munin/plugin-conf.d/apache" do
    source "munin/apache.erb"
    owner "root"
    group "root"
    mode "0644"
end


munin_plugin 'apache_accesses'
munin_plugin 'apache_volume'
munin_plugin 'apache_processes'
