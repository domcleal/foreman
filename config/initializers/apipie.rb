Apipie.configure do |config|
  config.app_name = "Foreman"
  config.app_info = "The Foreman is aimed to be a single address for all machines life cycle management."
  config.copyright = ""
  config.api_base_url = "/api"
  config.api_controllers_matcher = ["#{Rails.root}/app/controllers/api/**/*.rb"]
  config.ignored = []
  config.ignored_by_recorder = %w[]
  config.doc_base_url = "/apidoc"
  config.use_cache = Rails.env.production? || File.directory?(config.cache_dir)
  config.languages = [] # turn off localized API docs and CLI
  # config.languages = FastGettext.available_locales # generate API docs for all available locales
  config.default_locale = FastGettext.default_locale
  config.locale = lambda { |loc| loc ? FastGettext.set_locale(loc) : FastGettext.locale }
  config.translate = lambda do |str, loc|
    old_loc = FastGettext.locale
    FastGettext.set_locale(loc)
    trans = _(str) unless str.nil?
    FastGettext.set_locale(old_loc)
    trans
  end
  config.validate = false
  config.force_dsl = true
  config.reload_controllers = Rails.env.development?
  config.markup = Apipie::Markup::Markdown.new if Rails.env.development? and defined? Maruku
  config.default_version = "v1"
  config.update_checksum = true
  config.checksum_path = ['/api/', '/apidoc/']
end

unless Apipie.configuration.use_cache
  warn "The Apipie cache is turned off.\n" \
    "  To improve performance of your API clients turn it on by running 'rake apipie:cache' and restart the server."
end

# special type of validator: we say that it's not specified
class UndefValidator < Apipie::Validator::BaseValidator

  def validate(value)
    true
  end

  def self.build(param_description, argument, options, block)
    if argument == :undef
      self.new(param_description)
    end
  end

  def description
    nil
  end
end

class IdentifierValidator < Apipie::Validator::BaseValidator

  def validate(value)
    value = value.to_s
    value =~ /\A[\w| |_|-]*\Z/ && value.strip == value && (1..128).include?(value.length)
  end

  def self.build(param_description, argument, options, block)
    if argument == :identifier
      self.new(param_description)
    end
  end

  def description
    "Must be an identifier, string from 1 to 128 characters containing only alphanumeric characters, " +
        "space, underscore(_), hypen(-) with no leading or trailing space."
  end
end

class IdentifierDottableValidator < Apipie::Validator::BaseValidator

  def validate(value)
    value = value.to_s
    value =~ /\A[\w| |_|-|.]*\Z/ && value.strip == value && (1..128).include?(value.length)
  end

  def self.build(param_description, argument, options, block)
    if argument == :identifier_dottable
      self.new(param_description)
    end
  end

  def description
    "Must be an identifier, string from 1 to 128 characters containing only alphanumeric characters, " +
        "dot(.), space, underscore(_), hypen(-) with no leading or trailing space."
  end
end
