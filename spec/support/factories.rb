require 'factory_girl'

Factory.define :batch do |f|
  f.emails "foo@bar.com\nbaz@qux.org"
  f.association :ticket_kind
end

Factory.define :ticket_kind do |f|
  f.sequence(:title) { |n| "ticket_kind_#{n}"}
  f.prefix { |record| record.title.downcase.gsub(/\W/, '') }
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