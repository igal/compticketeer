# Setup ActionMailer based on the "config/secrets.yml" information:

configuration = {}
if SECRETS.notifier.kind_of?(Enumerable)
  for key, value in SECRETS.try(:notifier)
    key = key.to_sym
    if key == :authentication
      value = value.to_sym
    end
    configuration[key] = value
  end
end

ActionMailer::Base.smtp_settings = configuration
