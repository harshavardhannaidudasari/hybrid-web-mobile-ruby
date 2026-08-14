require_relative 'base_screen'

module HybridFramework
  module Pages
    module Mobile
      # BrowserStack's public iOS demo app (BStackSampleApp) - a simple
      # text button/input/output smoke-test screen, addressed by
      # accessibility id per BrowserStack's own sample repo
      # (ios/examples/run-first-test/specs/first_test.js).
      class BstackSampleScreen < BaseScreen
        TEXT_BUTTON = [:accessibility_id, 'Text Button'].freeze
        TEXT_INPUT = [:accessibility_id, 'Text Input'].freeze
        TEXT_OUTPUT = [:accessibility_id, 'Text Output'].freeze

        # BrowserStack's real devices are slower to respond to than a local
        # emulator, so give this screen longer explicit waits than the
        # BaseScreen default.
        WAIT_TIMEOUT = 30

        def initialize(driver)
          super(driver, timeout: WAIT_TIMEOUT)
        end

        def tap_text_button
          click(TEXT_BUTTON)
          self
        end

        def submit_text(text)
          input = find(TEXT_INPUT)
          input.click
          input.send_keys("#{text}\n")
          self
        end

        def output_text
          find(TEXT_OUTPUT).text
        end
      end
    end
  end
end
