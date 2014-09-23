default['monitoring']['check_vhost']['server_name'] = node['fqdn']
default['monitoring']['check_vhost']['ipaddress'] = node['ipaddress']

total_cpu = node['cpu']['total']

# Override the defaults for our environment, specifically redhat systems.
default['nagios']['client']['install_method'] = "package"
case node['platform_family']
when "rhel"
  default['nagios']['user'] = "nrpe"
  default['nagios']['group'] = "nrpe"
  default['nagios']['nrpe']['packages'] = [
    "nrpe",
    "nagios-plugins",
    "nagios-plugins-disk",
    "nagios-plugins-dummy",
    "nagios-plugins-linux_raid",
    "nagios-plugins-load",
    "nagios-plugins-mailq",
    "nagios-plugins-ntp",
    "nagios-plugins-procs",
    "nagios-plugins-swap",
    "nagios-plugins-users"
  ]
end

default['monitoring']['checks']['load']['warning'] =  "#{total_cpu * 2 + 10},#{total_cpu * 2 + 5},#{total_cpu * 2}"
default['monitoring']['checks']['load']['critical'] = "#{total_cpu * 4 + 10},#{total_cpu * 4 + 5},#{total_cpu * 4}"
