require 'serverspec'

include Serverspec::Helper::DetectOS
include Serverspec::Helper::Exec

describe file('/etc/munin/plugin-conf.d/haproxy') do
  it { should contain('env.url http://localhost:22002/haproxy-status;csv;norefresh') }
end

describe file('/etc/munin/plugins/haproxy_ng') do
  it { should be_linked_to '/usr/share/munin/plugins/haproxy_ng' }
end
