# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Include all helpers, all the time
  helper :all

  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  # Filters
  before_filter :authenticate

  protected

  # Return kind of authentication, e.g. :digest or :basic.
  def authentication_kind
    if defined?(@_authentication_kind) and not @_authentication_kind.nil?
      return @_authentication_kind
    else
      return @_authentication_kind = :basic
    end
  end

  # Set the authentication kind, e.g. :digest or :basic.
  def authentication_kind=(value)
    @_authentication_kind = value
  end

  # Should the user be authenticated?
  def authenticate?
    if defined?(@_authenticate) and not @_authenticate.nil?
      return @_authenticate
    else
      return @_authenticate = true
    end
  end

  # Change whether the user should be authenticated.
  def authenticate=(value)
    @_authenticate = value
  end

  # Authenticate the user.
  def authenticate
    if authenticate?
      # NOTE: Temporarily using HTTP Basic Auth because we can't figure out how
      # to set a sensible timeout for HTTP Digest Auth -- it seems to default
      # to 120 seconds, which is very annoying.
      case self.authentication_kind
      when :basic
        users_and_passwords = { SECRETS.username => SECRETS.password }
        authenticate_or_request_with_http_basic do |username, password|
          password ?
            password == users_and_passwords[username] :
            false
        end
      when :digest
        users_and_passwords = { SECRETS.username => SECRETS.password }
        users_and_digests = {}
        users_and_passwords.each_pair do |user, password|
          users_and_digests[user] = Digest::MD5::hexdigest([user, SECRETS.realm, password].join(":"))
        end

        authenticate_or_request_with_http_digest(SECRETS.realm) do |username|
          users_and_digests[username] || false
        end
      else
        raise ArgumentError, "Unknown autnethication kind: #{self.authentication_kind}"
      end
    end
  end
end
