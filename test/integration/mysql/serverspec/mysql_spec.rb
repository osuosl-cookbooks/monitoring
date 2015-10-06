require 'serverspec'

set :backend, :exec

describe file('/etc/nagios/mysql.cnf') do
  it do
    should contain("[client]\nuser = root\npassword = ilikerandompasswords")
  end
end

%w(processlist innodb pidfile replication-delay).each do |p|
  describe file("/etc/nagios/nrpe.d/pmp-check-mysql-#{p}.cfg") do
    it do
      should contain("command[pmp-check-mysql-#{p}]=\
/usr/lib64/nagios/plugins/pmp-check-mysql-#{p}")
    end
  end
end
