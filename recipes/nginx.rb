#
# Cookbook Name:: monitoring
# Recipe:: nginx
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
include_recipe "monitoring::http"
include_recipe "nginx::http_stub_status_module"

template "/etc/munin/plugin-conf.d/nginx" do
    source "munin/nginx.erb"
    owner "root"
    group "root"
    mode "0644"
end


munin_plugin 'nginx_request'
munin_plugin 'nginx_status'


