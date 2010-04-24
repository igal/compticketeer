# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_compticketeer_session',
  :secret      => '933fdd8c09b6205d6deabee46c07522fa23b7e58207d6c7eb95dcbb03f61fb64a74b5d049a8a7e2090205e0f1b359abc2b9c96511aff4f0fc621c284d9c276e0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
