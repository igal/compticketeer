# Stub SECRETS.eventbrite_data with valid data.
def stub_eventbrite_secrets
  SECRETS.stub!(:eventbrite_data => {
    'app_key'  => '123',
    'user_key' => '456',
    'event_id' => '789',
    'tickets'  => '123',
  })
end

# Stub SECRETS.eventbrite_data with invalid data.
def stub_invalid_eventbrite_secrets
  SECRETS.stub!(:eventbrite_data => {
    'app_key'  => 'test',
    'user_key' => 'test',
    'event_id' => 'test',
    'tickets'  => 'test',
  })
end
