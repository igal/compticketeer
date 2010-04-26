compticketeer
=============

This is a Ruby on Rails web application that issues complimentary tickets, such as free tickets to event speakers. An admin enters email addresses into this application, and it then generates unique discount code for each user and sends emails describing how to redeem them. This software currently only works with the EventBrite service.


Setup
-----

1. Install a Ruby interpreter compatible with MRI 1.8.7, RubyGems, Ruby on Rails 2.3.x, and Rake.
2. Run `rake gems:install` to install dependencies.
3. Create your database, e.g., run `rake db:create`.
4. Run `rake setup` to setup the application, database and create an admin user.


Secrets
-------

This application stores secret information like passwords in the `config/secrets.yml` file. This file should *never* be checked into revision control because it has secret information. A sample copy of this file is provided as `config/secrets.yml.sample` and will be used by default. You should copy this sample file to `config/secrets.yml` and customize it using the instructions in it.


License
-------

This program is provided under an MIT open source license, read the `LICENSE.txt` file for details.


Copyright
---------

Copyright (c) 2010 Open Source Bridge, Igal Koshevoy, Kirsten Comandich
