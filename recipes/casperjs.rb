#--------
# install phantomjs
#--------
remote_file "/tmp/phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}.tar.bz2" do
  source node["webscreenshots"]["phantomjs"]["uri"]
  mode "0644"
  action :create_if_missing
end

bash "install phantomjs" do
  cwd "/tmp"
  user "root"
  code <<-EOS
    tar -jxvf phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}.tar.bz2 >/dev/null
    rm -rf /opt/phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}
    mv phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}-linux-x86_64 /opt/phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}
    ln -sf /opt/casperjs-#{node["webscreenshots"]["phantomjs"]["version"]}/bin/casperjs /usr/local/bin/phantomjs
  EOS
  not_if "test -e /opt/phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}"
end

#--------
# install casperjs
#--------
remote_file "/tmp/casperjs-#{node["webscreenshots"]["casperjs"]["version"]}.tar.gz" do
  source node["webscreenshots"]["casperjs"]["uri"]
  mode "0644"
  action :create_if_missing
end

bash "install casperjs" do
  cwd "/tmp"
  user "root"
  code <<-EOS
    tar xfz casperjs-#{node["webscreenshots"]["casperjs"]["version"]}.tar.gz >/dev/null
    rm -rf /opt/casperjs-#{node["webscreenshots"]["casperjs"]["version"]}
    mv n1k0-casperjs-* /opt/casperjs-#{node["webscreenshots"]["casperjs"]["version"]}
    ln -sf /opt/casperjs-#{node["webscreenshots"]["casperjs"]["version"]}/bin/casperjs /usr/local/bin/casperjs
  EOS
  not_if "test -e /opt/casperjs-#{node["webscreenshots"]["casperjs"]["version"]}"
end
