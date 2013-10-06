default['nagios']['check_vhost']['server_name'] = node['fqdn']
default['nagios']['check_vhost']['ipaddress'] = node['ipaddress']

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