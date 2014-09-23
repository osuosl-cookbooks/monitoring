require 'serverspec'

include Serverspec::Helper::DetectOS
include Serverspec::Helper::Exec

describe package('perl-Crypt-SSLeay') do
  it { should be_installed }
end

describe file('/etc/munin/plugin-conf.d/apache') do
  it { should contain('env.url http://localhost:%d/server-status?auto') }
  it { should contain('env.port 80') }
end

%w[accesses volume processes].each do |p|
  describe file("/etc/munin/plugins/apache_#{p}") do
    it { should be_linked_to "/usr/share/munin/plugins/apache_#{p}" }
  end
end

%w[conf load].each do |c|
  describe file("/etc/httpd/mods-enabled/status.#{c}") do
    it { should be_linked_to "../mods-available/status.#{c}" }
  end
end
