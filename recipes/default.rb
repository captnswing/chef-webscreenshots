#--------
# install dependencies
#--------
include_recipe 'python'
include_recipe 'postgresql::server'

my_user = node['webscreenshots']['user']
my_group = node['webscreenshots']['group']
my_venv = node['webscreenshots']['venv_home']
python = "#{node['webscreenshots']['venv_home']}/bin/python"

#--------
# create required directories
#--------
%W(#{my_venv} #{my_venv}/etc/ #{my_venv}/var #{my_venv}/var/log #{my_venv}/var/run #{my_venv}/src).each do |dir|
  directory "#{dir}" do
    owner my_user
    group my_group
    mode '0755'
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
case node['platform_family']
  when 'debian'
    # for PIL / pillow
    package 'libjpeg8-dev'
    package 'libfreetype6-dev'
    # for flower
    package 'git-all'
    #for nginx
    package 'libgd2-xpm-dev'
  when 'rhel'
    # for PIL / pillow
    package 'libjpeg-devel'
    package 'libpng-devel'
    package 'freetype-devel'
end

#python_packages = %w(boto celery-with-redis distribute django git+git://github.com/mher/flower.git ipython pillow psycopg2 python-dateutil pytz uwsgi supervisor south)
#
#python_packages.each do |pypkg|
#  python_pip '#{pypkg}' do
#    virtualenv my_venv
#    user my_user
#    group my_group
#    action :install
#  end
#end

#--------
# install webscreenshots app
#--------
case node['platform_family']
  when 'debian'
    package 'mercurial'
end

execute 'clone repo' do
  user my_user
  group my_group
  cwd "#{node['webscreenshots']['project_root']}/src"
  command 'hg clone https://captnswing@bitbucket.org/captnswing/webscreenshots'
  creates "#{node['webscreenshots']['project_root']}/src/webscreenshots"
end

execute 'update repo' do
  user my_user
  group my_group
  cwd "#{node['webscreenshots']['project_root']}"
  command 'hg pull;  hg update'
#  command 'hg pull >/dev/null; hg update >/dev/null'
end

execute 'webscreenshots install' do
  user my_user
  group my_group
  cwd "#{node['webscreenshots']['project_root']}"
  command "#{python} setup.py develop"
end

execute 'webscreenshots syncdb' do
  user my_user
  group my_group
  cwd "#{node['webscreenshots']['project_root']}/src/webscreenshots"
  command "export DJANGO_SETTINGS_MODULE=#{node['webscreenshots']['django_settings_module']}; #{python} manage.py syncdb --noinput >/dev/null"
end

execute 'webscreenshots migrate' do
  user my_user
  group my_group
  cwd "#{node['webscreenshots']['project_root']}/src/webscreenshots"
  command "export DJANGO_SETTINGS_MODULE=#{node['webscreenshots']['django_settings_module']}; #{python} manage.py migrate main"
end

if node['webscreenshots']['vagrant']
  execute 'django runserver' do
    user my_user
    group my_group
    cwd "#{node['webscreenshots']['project_root']}/src/webscreenshots"
    command "export DJANGO_SETTINGS_MODULE=#{node['webscreenshots']['django_settings_module']};#{python} manage.py runserver 0.0.0.0:8000 &"
  end
end

include_recipe 'redisio::install'
include_recipe 'redisio::disable' # using supervisord
include_recipe 'webscreenshots::phantomjs'
include_recipe 'webscreenshots::supervisord'
include_recipe 'nginx'

template "#{node['webscreenshots']['venv_home']}/etc/uwsgi.ini" do
  source 'uwsgi.ini.erb'
  owner my_user
  group my_group
  mode 0644
  notifies :restart, 'service[supervisor]'
end

template '/etc/nginx/conf.d/webscreenshots.conf' do
  source 'nginx-webscreenshots.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'service[nginx]'
end

case node['platform']
  when 'ubuntu'
    bash 'disable apache2' do
      user 'root'
      code <<-EOS
        update-rc.d -f apache2 remove
        /usr/sbin/apachectl stop
      EOS
      only_if 'ls /etc/rc*.d/* | grep apache2'
    end
end
