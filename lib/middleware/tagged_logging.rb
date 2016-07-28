require 'openssl'

module Middleware
  class TaggedLogging
    def initialize(app)
      @app = app
    end

    def call(env)
      ::Logging.mdc['request'] = env['action_dispatch.request_id']

      request = ActionDispatch::Request.new(env)
      session_id = request.cookie_jar['_session_id']
      ::Logging.mdc['session'] = if session_id.present?
                                   digest_id(session_id)
                                 else
                                   env['action_dispatch.request_id']
                                 end

      @app.call(env)
    ensure
      ::Logging.mdc.delete('request')
      ::Logging.mdc.delete('session')
    end

    private

    # Prefer using a digest of the session ID so it can be passed safely to external smart proxies
    # etc to prevent session hijacks
    def digest_id(id)
      salt = defined?(EncryptionKey::ENCRYPTION_KEY) ? EncryptionKey::ENCRYPTION_KEY : 'default'
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), salt, id)
    end
  end
end
