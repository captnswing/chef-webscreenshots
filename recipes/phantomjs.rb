#--------
# install phantomjs
#--------
remote_file "/tmp/phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}.tar.bz2" do
  source node["webscreenshots"]["phantomjs"]["uri"]
  mode "0644"
  action :create_if_missing
  not_if "test -e /opt/phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}-linux-x86_64"
end

bash "install phantomjs" do
  cwd "/tmp"
  user "root"
  code <<-EOS
    tar -jxvf phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}.tar.bz2 >/dev/null
    mv phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}-linux-x86_64 /opt
  EOS
  not_if "test -e /opt/phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}-linux-x86_64"
end
