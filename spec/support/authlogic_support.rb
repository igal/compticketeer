require "authlogic/test_case"

include Authlogic::TestCase

def login_as(user)
  activate_authlogic
  UserSession.create(user)
end

def login_as_admin
  user = Factory :user
  login_as user
end