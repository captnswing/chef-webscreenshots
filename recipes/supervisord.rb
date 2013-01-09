#--------
# install supervisord
#--------
template "/etc/init/supervisor.conf" do
  source "supervisor-upstart.erb"
  mode 0644
end

template "#{node["webscreenshots"]["home"]}/etc/supervisord.conf" do
  source "supervisord.conf.erb"
  mode 0644
  owner node["webscreenshots"]["user"]
  group node["webscreenshots"]["group"]
  notifies :restart, "service[supervisor]"
end

service "supervisor" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  action [:enable, :start]
end

#TODO: ~/.boto.cfg
#template "#{node["webscreenshots"]["home"]}/.boto.cfg" do
# from http://stackoverflow.com/a/9197801/41404
template "/etc/boto.cfg" do
  source "boto.cfg.erb"
  mode 0644
  notifies :restart, "service[supervisor]"
end
