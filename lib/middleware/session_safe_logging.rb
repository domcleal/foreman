require 'securerandom'

module Middleware
  class SessionSafeLogging
    def initialize(app)
      @app = app
    end

    def call(env)
      session = env['rack.session']
      session['session_safe'] ||= SecureRandom.uuid
      ::Logging.mdc['session_safe'] = session['session_safe']

      @app.call(env)
    ensure
      ::Logging.mdc.delete('session_safe')
    end
  end
end
