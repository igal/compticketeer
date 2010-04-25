compticketeer
=============

This is a Ruby on Rails web app that provides a way to issue complimentary tickets -- e.g., free tickets to speakers. An admin enters email addresses into this application, and it then generates unique discount code for each user and sends emails describing how to use them to redeem a ticket. The software currently only works with EventBrite.

Setup
-----

1. Install a Ruby interpreter compatible with MRI 1.8.7, RubyGems, Ruby on Rails 2.3.x, and Rake.
2. Run `rake gems:install` to install dependencies.
3. Create your database, e.g., run `rake db:create`.
4. Run `rake setup` to setup the application and create an admin user.
