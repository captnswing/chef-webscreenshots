default["webscreenshots"]["user"] = "ubuntu"
default["webscreenshots"]["group"] = "ubuntu"
default["webscreenshots"]["venv_home"] = "/opt/webscreenshots"
default['webscreenshots']['project_root'] = "#{node['webscreenshots']['venv_home']}/src/webscreenshots"

# test
#default["webscreenshots"]["cloudfront_server"] = "http://d1jdinwdjyvmyt.cloudfront.net"
#default["webscreenshots"]["django_settings_module"] = "webscreenshots.settings.test"

# prod
default["webscreenshots"]["cloudfront_server"] = "http://d2np6cnk6s6ggj.cloudfront.net"
default["webscreenshots"]["django_settings_module"] = "webscreenshots.settings.prod"

# required for chef-solo
default["postgresql"]["password"]["postgres"] = "postgres"

default["nginx"]["install_method"] = "source"
default["nginx"]["configure_flags"] = ["--with-http_image_filter_module"]
#default["nginx"]["version"] = "1.4.1"
#default["nginx"]["source"]["version"] = "1.4.1"
#default["nginx"]["source"]["checksum"] = "84aeb7a131fccff036dc80283dd98c989d2844eb84359cfe7c4863475de923a9" # shasum -a 256 nginx-1.4.1.tar.gz
