##
# A MySQL connection:
# DataMapper.setup(:default, 'mysql://user:password@localhost/the_database_name')
#
# # A Postgres connection:
# DataMapper.setup(:default, 'postgres://user:password@localhost/the_database_name')
#
# # A Sqlite3 connection
# DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "development.db"))
#

DataMapper.logger = logger
DataMapper::Property::String.length(255)

# Migrations and seeding.
#
# `bundle exec vmc tunnel` into the Posgresql CF instance.
# 
# Edit the below manual database connection string. Once you've done that:
#
# `PADRINO_ENV=production rake dm:migrate`
# `PADRINO_ENV=production rake seed`
#
# While being connected to the remote database.
#
# postgres_connection = "postgres://username:password@127.0.0.1:port/name" 

if ENV['VCAP_SERVICES'].nil? # Not on Cloudfoundry - probably on Heroku.
	postgres_connection = ENV["DATABASE_URL"]
else
	services = JSON.parse(ENV['VCAP_SERVICES'])
	postgresql_key = services.keys.select { |svc| svc =~ /postgresql/i }.first
	postgresql = services[postgresql_key].first['credentials']
	postgres_connection = "postgres://#{postgresql['user']}:#{postgresql['password']}@#{postgresql['hostname']}:#{postgresql['port']}/#{postgresql['name']}" 	
end

case Padrino.env
  	when :development then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "development.db"))
  	when :production  then DataMapper.setup(:default, postgres_connection)
  	when :test        then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "test.db"))
end
