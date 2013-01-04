#--------
# install redis
#--------
case node["platform_family"]
  when "debian"
    package "make"
  when "rhel"
    #package "make"?
end

remote_file "/tmp/redis-#{node["webscreenshots"]["redis"]["version"]}.tar.gz" do
  owner node["webscreenshots"]["user"]
  group node["webscreenshots"]["group"]
  source node["webscreenshots"]["redis"]["tar_url"]
  checksum node["webscreenshots"]["redis"]["checksum"]
  mode "0644"
  action :create_if_missing
  not_if "test -e #{node["webscreenshots"]["home"]}/bin/redis-server"
end

execute "extract redis.tar" do
  cwd "/tmp"
  user node["webscreenshots"]["user"]
  group node["webscreenshots"]["group"]
  command "tar zxf redis-#{node["webscreenshots"]["redis"]["version"]}.tar.gz"
  creates "/tmp/redis-#{node["webscreenshots"]["redis"]["version"]}/README"
  not_if "test -e #{node["webscreenshots"]["home"]}/bin/redis-server"
end

execute "build & install redis" do
  user node["webscreenshots"]["user"]
  group node["webscreenshots"]["group"]
  cwd "/tmp/redis-#{node["webscreenshots"]["redis"]["version"]}"
  command "make install PREFIX=#{node["webscreenshots"]["home"]} >/dev/null"
  creates "#{node["webscreenshots"]["home"]}/bin/redis-server"
end

#TODO: redis.conf, location of db
#directory "#{node["webscreenshots"]["home"]}/var/lib/redis" do
#  owner node["webscreenshots"]["user"]
#  group node["webscreenshots"]["group"]
#  mode "0750"
#  recursive true
#end
