#--------
# install phantomjs
#--------
# from http://skookum.com/blog/dynamic-screenshots-on-the-server-with-phantomjs/
remote_file "/tmp/phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}.tar.bz2" do
  source node["webscreenshots"]["phantomjs"]["uri"]
  mode "0644"
  action :create_if_missing
end

bash "install phantomjs" do
  cwd "/tmp"
  user "root"
  code <<-EOS
    tar -jxvf phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}.tar.bz2
    mv phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}-linux-x86_64 /opt
  EOS
  creates "/opt/phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}-linux-x86_64"
end
