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
%W(#{my_venv} #{my_venv}/etc/ #{my_venv}/var #{my_venv}/var/log #{my_venv}/var/run #{my_venv}/src #{node['webscreenshots']['project_root']}).each do |dir|
  directory "#{dir}" do
    owner my_user
    group my_group
    mode '0755'
    action :create
    recursive true
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
# install prerequisites for python packages
#--------
case node['platform_family']
  when 'debian'
    # for PIL / pillow
    package 'libjpeg8-dev'
    package 'libfreetype6-dev'
    # for flower
    package 'git-all'
    # for nginx
    package 'libgd2-xpm-dev'
  when 'rhel'
    # for PIL / pillow
    package 'libjpeg-devel'
    package 'libpng-devel'
    package 'freetype-devel'
end

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
  cwd "#{node['webscreenshots']['project_root']}/../"
  command 'hg clone https://captnswing@bitbucket.org/captnswing/webscreenshots'
  not_if "test -e #{node['webscreenshots']['project_root']}/src/webscreenshots"
end

execute 'update repo' do
  user my_user
  group my_group
  cwd "#{node['webscreenshots']['project_root']}"
  command 'hg pull >/dev/null; hg update >/dev/null'
end

execute 'webscreenshots install' do
  user my_user
  group my_group
  cwd "#{node['webscreenshots']['project_root']}"
  command "#{python} setup.py develop >/dev/null"
end

bash 'webscreenshots createdb' do
  user my_user
  cwd "#{node['webscreenshots']['project_root']}/src/webscreenshots"
  code <<-EOS
    export DJANGO_SETTINGS_MODULE=#{node['webscreenshots']['django_settings_module']}
    #{python} manage.py syncdb --noinput
    #{python} manage.py migrate main
    #{python} manage.py loaddata initial_data
  EOS
end

include_recipe 'redisio::install'
include_recipe 'redisio::disable' # using supervisord instead
include_recipe 'webscreenshots::casperjs'
include_recipe 'webscreenshots::supervisord'
include_recipe 'nginx'

template "#{node['webscreenshots']['venv_home']}/etc/uwsgi.ini" do
  source 'uwsgi.ini.erb'
  owner my_user
  group my_group
  mode 0644
  notifies :restart, 'service[supervisor]'
end

template "#{node['nginx']['dir']}/webscreenshots.conf" do
  source 'nginx-webscreenshots.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[nginx]'
end

template "#{node['nginx']['dir']}/nginx.conf" do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[nginx]'
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
