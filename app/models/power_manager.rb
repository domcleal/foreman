class PowerManager
  SUPPORTED_ACTIONS = [:start, :stop, :poweroff, :reboot, :reset, :state]

  def initialize(opts = {})
    @host = opts[:host]
  end

  def self.method_missing(method, *args)
    logger.warn "invalid power state request #{action} for host: #{host}"
    raise ::Foreman::Exception.new(N_("Invalid power state request: %s, supported actions are %s"), action, SUPPORTED_ACTIONS)
  end

  def state
    N_("Unknown")
  end

  def logger
    Rails.logger
  end

  private
  attr_reader :host

end