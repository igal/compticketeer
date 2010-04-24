# From http://lightyearsoftware.com/blog/2009/04/testing-http-digest-authentication-in-rails/

require 'digest/md5'

class ActionController::TestCase
  def authenticate_with_http_digest(user = SECRETS.username, password = SECRETS.password, realm = SECRETS.realm)
    unless ActionController::Base < ActionController::ProcessWithTest
      ActionController::Base.class_eval { include ActionController::ProcessWithTest }
    end

    @controller.instance_eval <<-EOB
      alias real_process_with_test process_with_test
      def process_with_test(request, response)
        false
        credentials = {
          :uri => request.env['REQUEST_URI'],
          :realm => "#{realm}",
          :username => "#{user}",
          :nonce => ActionController::HttpAuthentication::Digest.nonce,
          :opaque => ActionController::HttpAuthentication::Digest.opaque,
        }
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Digest.encode_credentials(
          request.request_method, credentials, "#{password}", false
        )
        real_process_with_test(request, response)
      end
    EOB
  end
end