#
# Cookbook Name:: md-test
# Recipe:: default
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

drives = 2

drives.times do |i|
  unless File.exists?("/root/raid-#{i}")
    execute "dd if=/dev/zero of=/root/raid-#{i} bs=1M count=10" do
      action :nothing
    end.run_action(:run)
    execute "losetup /dev/loop#{i} /root/raid-#{i}" do
      action :nothing
    end.run_action(:run)
  end
end

mdadm "/dev/md0" do
  devices drives.times.map{|i| "/dev/loop#{i}"}
  level 1
  action :nothing
end.run_action(:create)

ohai "reload" do
  action :nothing
end.run_action(:reload)
