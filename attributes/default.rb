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

# can't get it to work with runit, see https://tickets.opscode.com/browse/COOK-2049
default["nginx"]["init_style"] = "init"
default["nginx"]["install_method"] = "source"
default["nginx"]["source"]["prefix"] = "/opt/nginx"
default["nginx"]["source"]["url"] = "http://nginx.org/download/nginx-1.4.1.tar.gz"
default["nginx"]["source"]["version"] = "1.4.1"
# shasum -a 256 nginx-1.4.1.tar.gz
default["nginx"]["source"]["checksum"] = "84aeb7a131fccff036dc80283dd98c989d2844eb84359cfe7c4863475de923a9"
default["nginx"]["source"]["default_configure_flags"] = ["--prefix=/opt/nginx-#{node["nginx"]["source"]["version"]} --with-http_image_filter_module"]
