require 'erb'
require 'yaml'

dist_settings_file = File.expand_path('../settings.yaml.dist', __FILE__)
SETTINGS = File.exist?(dist_settings_file) ? YAML.load(ERB.new(File.read(dist_settings_file)).result) || {} : {}

settings_file = File.expand_path('../settings.yaml', __FILE__)
SETTINGS.merge! YAML.load(ERB.new(File.read(settings_file)).result).select { |k,v| k == :rails }

SETTINGS[:rails] ||= RUBY_VERSION < '2.4' ? '5.0' : '5.1'
SETTINGS[:rails] = '%.1f' % SETTINGS[:rails] if SETTINGS[:rails].is_a?(Float) # unquoted YAML value
