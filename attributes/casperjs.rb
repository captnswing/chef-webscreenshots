default["webscreenshots"]["casperjs"]["version"] = "1.0.2"
default["webscreenshots"]["casperjs"]["uri"] = "https://github.com/n1k0/casperjs/tarball/#{node["webscreenshots"]["casperjs"]["version"]}"

default["webscreenshots"]["phantomjs"]["version"] = "1.9.0"
default["webscreenshots"]["phantomjs"]["arch"] = "x86_64" # or "i686"
default["webscreenshots"]["phantomjs"]["uri"] = "http://phantomjs.googlecode.com/files/phantomjs-#{node["webscreenshots"]["phantomjs"]["version"]}-linux-#{node["webscreenshots"]["phantomjs"]["arch"]}.tar.bz2"
