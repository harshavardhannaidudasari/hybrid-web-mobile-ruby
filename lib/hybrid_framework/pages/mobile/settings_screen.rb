require_relative 'base_screen'

module HybridFramework
  module Pages
    module Mobile
      # Android Settings app search screen - no custom APK required.
      class SettingsScreen < BaseScreen
        SEARCH_ICON = [:accessibility_id, 'Search settings'].freeze
        SEARCH_BOX = [:uiautomator, 'new UiSelector().resourceId("android:id/search_src_text")'].freeze
        RESULT_TITLES = [:uiautomator, 'new UiSelector().resourceId("android:id/title")'].freeze

        def open_search
          click(SEARCH_ICON)
          self
        end

        def search_for(query)
          type(SEARCH_BOX, query)
          self
        end

        def results
          @driver.find_elements(*RESULT_TITLES)
        end
      end
    end
  end
end
