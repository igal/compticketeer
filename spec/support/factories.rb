require 'factory_girl'

Factory.define :batch do |f|
  f.emails "foo@bar.com\nbaz@qux.org"
  f.association :ticket_kind
  f.created_at Time.now
end

Factory.define :ticket_kind do |f|
  f.sequence(:title) { |n| "ticket_kind_#{n}"}
  f.template "Template text here!"
end

Factory.define :ticket do |f|
  f.association :ticket_kind
  f.association :batch
  f.sequence(:email) { |n| "ticket_#{n}@provider.com"}
  f.processed true
  f.error nil
  f.processed_at Time.now
end

Factory.define :user do |f|
  f.sequence(:login) { |n| "login_#{n}"}
  f.email { |r| "#{r.login.downcase}@provider.com" }
  f.password "mypassword"
  f.password_confirmation "mypassword"
  f.password_salt { |r| Authlogic::Random.hex_token }
  f.crypted_password { |r| Authlogic::CryptoProviders::Sha512.encrypt(r.login + r.password_salt) }
  f.persistence_token { |r| Authlogic::Random.hex_token }
  f.single_access_token { |r| Authlogic::Random.friendly_token }
  f.perishable_token { |r| Authlogic::Random.friendly_token }
end
