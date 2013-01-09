#--------
# install dependencies
#--------
include_recipe "python"
include_recipe "postgresql::server"

my_user = node["webscreenshots"]["user"]
my_group = node["webscreenshots"]["group"]
my_venv = node["webscreenshots"]["home"]

#--------
# create group and user
#--------
group my_group

user my_user do
  gid my_group
  home my_venv
  shell "/bin/bash"
  system true
end

#--------
# create required directories
#--------
["#{my_venv}", "#{my_venv}/etc/", "#{my_venv}/var", "#{my_venv}/var/log", "#{my_venv}/var/run", "#{my_venv}/src"].each do |dir|
  directory "#{dir}" do
    owner my_user
    group my_group
    mode "0755"
  end
end

#--------
# create venv
#--------
python_virtualenv my_venv do
  owner my_user
  group my_group
  action :create
end

#--------
# install python packages into venv
#--------
case node["platform_family"]
  when "debian"
    # for PIL / pillow
    package "libjpeg8-dev"
    package "libfreetype6-dev"
    # for flower
    package "git-all"
    #for nginx
    package "libgd2-xpm-dev"
  when "rhel"
    # for PIL / pillow
    package "libjpeg-devel"
    package "libpng-devel"
    package "freetype-devel"
end

python_packages = [
    "boto",
    "celery-with-redis",
    "distribute",
    "django",
    "git+git://github.com/mher/flower.git",
    #"flower",
    "gunicorn",
    "ipython",
    # PIL --> pillow, see http://stackoverflow.com/a/12359864/41404
    "pillow",
    "psycopg2",
    "python-dateutil",
    "pytz",
    "uwsgi",
    "supervisor"
]

python_packages.each do |pypkg|
  python_pip "#{pypkg}" do
    virtualenv my_venv
    user my_user
    group my_group
    action :install
  end
end

#--------
# install webscreenshots app
#--------
if node["webscreenshots"]["vagrant"]
  node.set["webscreenshots"]["working_dir"] = "/vagrant"
else
  node.set["webscreenshots"]["working_dir"] = "#{node["webscreenshots"]["home"]}/src/webscreenshots"

  case node["platform_family"]
    when "debian"
      package "mercurial"
  end

  execute "clone repo" do
    user my_user
    group my_group
    cwd "#{node["webscreenshots"]["home"]}/src"
    command "hg clone https://captnswing@bitbucket.org/captnswing/webscreenshots"
    creates "#{node["webscreenshots"]["working_dir"]}"
  end

  execute "update repo" do
    user my_user
    group my_group
    cwd "#{node["webscreenshots"]["working_dir"]}"
    command "hg pull >/dev/null; hg update >/dev/null"
  end
end

execute "install webscreenshots" do
  #user my_user
  #group my_group
  cwd "#{node["webscreenshots"]["working_dir"]}"
  command "#{node["webscreenshots"]["home"]}/bin/python setup.py develop >/dev/null"
end

execute "webscreenshots syncdb" do
  user my_user
  group my_group
  cwd "#{node["webscreenshots"]["working_dir"]}/src/webscreenshots"
  command "#{node["webscreenshots"]["home"]}/bin/python manage.py syncdb --noinput >/dev/null"
end

include_recipe "webscreenshots::redis"
include_recipe "webscreenshots::phantomjs"
include_recipe "webscreenshots::supervisord"
include_recipe "nginx::source"

template "#{node["webscreenshots"]["home"]}/etc/uwsgi.ini" do
  source "uwsgi.ini.erb"
  owner my_user
  group my_group
  mode 0644
  notifies :restart, "service[supervisor]"
end

template "/etc/nginx/conf.d/webscreenshots.conf" do
  source "nginx-webscreenshots.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[nginx]"
end

case node["platform"]
  when "ubuntu"
    bash "disable apache2" do
      user "root"
      code <<-EOS
        update-rc.d -f apache2 remove
        /usr/sbin/apachectl stop
      EOS
      only_if "ls /etc/rc*.d/* | grep apache2"
    end
end
