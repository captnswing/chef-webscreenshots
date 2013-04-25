default["webscreenshots"]["user"] = "ubuntu"
default["webscreenshots"]["group"] = "ubuntu"
default["webscreenshots"]["venv_home"] = "/opt/webscreenshots"
default["webscreenshots"]["cloudfront_server"] = "http://d2np6cnk6s6ggj.cloudfront.net"
default["webscreenshots"]["django_settings_module"] = "webscreenshots.settings.prod"

# running as vagrant?
default["webscreenshots"]["vagrant"] = node["kernel"]["modules"].attribute?("vboxguest")

default['webscreenshots']['project_root'] = "#{node['webscreenshots']['venv_home']}"

# required for chef-solo
set["postgresql"]["password"]["postgres"] = "postgres"

default["nginx"]["install_method"] = "source"
default["nginx"]["source"]["url"] = "http://nginx.org/download/nginx-1.4.0.tar.gz"
# shasum -a 256 nginx-1.4.0.tar.gz
default["nginx"]["source"]["checksum"] = "84aeb7a131fccff036dc80283dd98c989d2844eb84359cfe7c4863475de923a9"
default["nginx"]["source"]["default_configure_flags"] = ["--with-http_image_filter_module"]
