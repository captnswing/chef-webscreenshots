default["webscreenshots"]["supervisord"]["logdir"] = "#{node["webscreenshots"]["home"]}/var/log"
default["webscreenshots"]["supervisord"]["piddir"] = "#{node["webscreenshots"]["home"]}/var/run"
default["webscreenshots"]["supervisord"]["cfgfile"] = "#{node["webscreenshots"]["home"]}/etc/supervisord.conf"
