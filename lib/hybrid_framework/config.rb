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

    # Some external providers (e.g. BrowserStack) document their own plain
    # env var names directly (BROWSERSTACK_USERNAME, etc). Check that exact
    # name first, then fall back to the normal HYBRID_<KEY> / config.yml
    # lookup via #get so the usual override convention still applies.
    def self.get_with_env_alias(env_name, path, fallback = nil)
      return ENV[env_name] if ENV.key?(env_name)

      get(path, fallback)
    end
  end
end
