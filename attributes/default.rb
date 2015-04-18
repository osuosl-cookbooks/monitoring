default['monitoring']['check_all_disks']['warning'] = "8%"
default['monitoring']['check_all_disks']['critical'] = "5%"
default['monitoring']['check_all_disks']['parameters'] = "-A -x /dev/shm -X nfs -X fuse.glusterfs -i /boot"
default['monitoring']['check_swap']['warning'] = "15%"
default['monitoring']['check_swap']['critical'] = "5%"

total_cpu = node['cpu']['total']
default['monitoring']['check_load']['warning'] =  "#{total_cpu * 2 + 10},#{total_cpu * 2 + 5},#{total_cpu * 2}"
default['monitoring']['check_load']['critical'] = "#{total_cpu * 4 + 10},#{total_cpu * 4 + 5},#{total_cpu * 4}"

# Override the defaults for our environment, specifically redhat systems.
default['nagios']['client']['install_method'] = "package"
case node['platform_family']
when 'rhel', 'fedora'
  nrpe_packages = %w(
    nrpe
    nagios-plugins
    nagios-plugins-disk
    nagios-plugins-dummy
    nagios-plugins-load
    nagios-plugins-mailq
    nagios-plugins-ntp
    nagios-plugins-procs
    nagios-plugins-swap
    nagios-plugins-users
  )

  default['nagios']['user'] = 'nrpe'
  default['nagios']['group'] = 'nrpe'
  if (platform_family?('rhel') && node['platform_version'].to_i < 7) ||
     (platform_family?('fedora') && node['platform_version'].to_i < 21)
    nrpe_packages << 'nagios-plugins-linux_raid'
  end
end
default['nagios']['nrpe']['packages'] = nrpe_packages
