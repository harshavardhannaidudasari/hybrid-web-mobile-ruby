require 'yaml'

module HybridFramework
  # Dotted-key lookup over config/config.yml, e.g. Config.get('web.base_url').
  # HYBRID_<DOTTED_KEY_UPCASED> environment variables take precedence.
  module Config
    DEFAULTS = YAML.load_file(File.expand_path('../../config/config.yml', __dir__))

    def self.get(path, fallback = nil)
      env_key = "HYBRID_#{path.tr('.', '_').upcase}"
      return ENV[env_key] if ENV.key?(env_key)

      value = path.split('.').inject(DEFAULTS) do |node, key|
        node.is_a?(Hash) ? node[key] : nil
      end
      value.nil? ? fallback : value
    end
  end
end
