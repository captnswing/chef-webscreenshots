default["webscreenshots"]["user"] = "ubuntu"
default["webscreenshots"]["group"] = "ubuntu"
default["webscreenshots"]["venv_home"] = "/opt/webscreenshots"
default["webscreenshots"]["cloudfront_server"] = "http://d2np6cnk6s6ggj.cloudfront.net"
default["webscreenshots"]["django_settings_module"] = "webscreenshots.settings.test"

# running as vagrant?
default["webscreenshots"]["vagrant"] = node["kernel"]["modules"].attribute?("vboxguest")

default['webscreenshots']['project_root'] = "#{node['webscreenshots']['venv_home']}"

# required for chef-solo
set["postgresql"]["password"]["postgres"] = "postgres"

default["nginx"]["install_method"] = "source"
#default["nginx"]["version"] = "1.3.14"
# shasum -a 256 nginx-1.3.14.tar.gz
#default["nginx"]["source"]["checksum"] = "b7ea92ac5e3d716c1b43b927547d3a89b0e35e3a6edecad64cf1914f82494950"
#default['nginx']['source']['modules'] = [
#  "http_ssl_module",
#  "http_gzip_static_module",
#  "http_image_filter_module"
#]
default["nginx"]["configure_flags"] = ["--with-http_image_filter_module"]
