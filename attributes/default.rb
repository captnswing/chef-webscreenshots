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

# running as vagrant?
default["webscreenshots"]["vagrant"] = node["kernel"]["modules"].attribute?("vboxguest")

# required for chef-solo
set["postgresql"]["password"]["postgres"] = "postgres"

override["nginx"]["version"] = "1.3.10"
override["nginx"]["source"]["checksum"] = "248c43a4f77b9add6eaad2"
override["nginx"]["configure_flags"] = ["--with-http_image_filter_module"]
