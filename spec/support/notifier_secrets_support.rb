# Provide sensible settings for the notifier secrets:
def stub_notifier_secrets
  SECRETS.stub!(:notifier => {
    'address' => 'myprovider.com',
    'port' => 587,
    'authentication' => 'plain',
    'enable_starttls_auto' => true,
    'user_name' => 'test',
    'password' => 'test',
  })
end