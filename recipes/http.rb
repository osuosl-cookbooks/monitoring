package "nagios-plugins-http" do
  action :install
end

# Check http
nagios_nrpecheck "check_http" do
  command "#{node['nagios']['plugin_dir']}/check_http"
  parameters "-H #{node['nagios']['check_vhost']['server_name']} -I #{node['nagios']['check_vhost']['ipaddress']}"
  action :add
end
