default["webscreenshots"]["s3bucketname"] = "svti-webscreenshots"

# IAM user with access to configured S3 bucket
# http://docs.amazonwebservices.com/IAM/latest/UserGuide/GSGHowToCreateAdminsGroup.html
default["webscreenshots"]["iam"]["username"] = "webscreenshots"
# TODO: encrypted databags with chef solo?
default["webscreenshots"]["iam"]["accesskeyid"] = "AKIAJGUNM2DBSJAZ777Q"
default["webscreenshots"]["iam"]["secretkey"] = "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"

default["webscreenshots"]["user"] = "webscreenshots"
default["webscreenshots"]["group"] = "webscreenshots"
default["webscreenshots"]["home"] = "/opt/webscreenshots"
default["webscreenshots"]["cloudfront_server"] = "http://d2np6cnk6s6ggj.cloudfront.net"
default["webscreenshots"]["django_settings_module"] = "webscreenshots.settings.prod"

# running as vagrant?
default["webscreenshots"]["vagrant"] = node["kernel"]["modules"].attribute?("vboxguest")

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
