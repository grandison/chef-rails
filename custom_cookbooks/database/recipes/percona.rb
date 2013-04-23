# Install Percona

include_recipe 'percona::package_repo'
include_recipe 'percona::client'
include_recipe 'percona::server'
include_recipe 'percona::backup'

# FIXME: can't use chef_gem here :(
# https://github.com/rubygems/rubygems/issues/502
bash 'install mysql gem' do
  code 'gem install mysql --no-ri --no-rdoc'
end

mysql_connection_info = { :host     => node[:database][:host],
                          :username => 'root',
                          :password => node[:percona][:server][:root_password] }

mysql_database node[:database][:name] do
  connection mysql_connection_info

  action :create
end

mysql_database_user node[:database][:user] do
  connection mysql_connection_info
  password node[:database][:password]
  database_name node[:database][:name]
  privileges [:all]

  action :grant
end
