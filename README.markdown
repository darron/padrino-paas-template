Padrino on Heroku or Cloudfoundry
==================================

I wanted to deploy Padrino on Heroku or Cloudfoundry but couldn't find information that worked 100% for me. So I worked through the steps and documentation I could find and built this so I'd never have to do it again.

You can clone this project and jump to the "heroku create" or "vmc push" step OR create your own this way:

    padrino g project $PROJECT_NAME -t rspec -e erb -c less -s jquery -d datamapper -a postgres -b
    cd $PROJECT_NAME/
    curl "https://raw.github.com/darron/padrino-paas-template/master/Gemfile" -o Gemfile
    # If you're not using rspec/erb/less/datamapper - you may need to edit the Gemfile with those changes.
    bundle install
    padrino g admin
    curl "https://raw.github.com/darron/padrino-paas-template/master/config/database.rb" -o config/database.rb
    curl "https://raw.github.com/darron/padrino-paas-template/master/config/unicorn.rb" -o config/unicorn.rb
    curl "https://raw.github.com/darron/padrino-paas-template/master/Procfile" -o Procfile
    padrino rake gen
    git init .
    git add .
    git commit -a -m 'First commit.'

For Heroku:

    heroku create $PROJECT_NAME
    git push heroku master
    heroku run rake dm:migrate
    heroku run rake seed
    # For local development
    padrino rake dm:migrate
    padrino rake seed

Cloudfoundry is a bit of a pain because they don't have something like "heroku run" for the migrations and seeding - but it does work:

    bundle exec vmc login
    bundle exec vmc push --runtime ruby19 # Make sure to attach Postgres as a service.
    bundle exec vmc tunnel # Pick Postgres - then make sure to note all of the details they show once you're connected.
    # Edit the config/database.rb with the tunnel values for the postgres_connection - comment out the if/else
    PADRINO_ENV=production rake dm:migrate
    PADRINO_ENV=production rake seed

When deployed this app:

1. Uses Unicorn on Heroku for app serving - start it in local development mode with `foreman start` (Honestly not sure what it's using on Cloudfoundry.)
2. Uses Postgres for the database - SQLite in local development mode.
3. Has a basic admin interface created - more information [here](http://www.padrinorb.com/guides/padrino-admin).
4. Uses [Datamapper](http://datamapper.org) for the ORM.

Thanks to:

[https://gist.github.com/selman/569310](https://gist.github.com/selman/569310)

[http://datachomp.com/archives/using-unicorn-with-sinatra-or-padrino-on-heroku/](http://datachomp.com/archives/using-unicorn-with-sinatra-or-padrino-on-heroku/)

[http://www.padrinorb.com/guides/blog-tutorial#deploying-our-application](http://www.padrinorb.com/guides/blog-tutorial#deploying-our-application)
