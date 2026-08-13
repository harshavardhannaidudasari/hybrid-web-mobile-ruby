require_relative 'base_screen'

module HybridFramework
  module Pages
    module Mobile
      # Android Settings app search screen - no custom APK required.
      class SettingsScreen < BaseScreen
        SEARCH_ICON = [:uiautomator, 'new UiSelector().resourceId("com.android.settings:id/search_action_bar")'].freeze
        # Tapping the search bar hands off to the separate Settings
        # Suggestions (search) app, whose edit text lives under its own
        # package id.
        SEARCH_BOX = [:uiautomator,
                      'new UiSelector().resourceId("com.google.android.settings.intelligence:id/open_search_view_edit_text")'].freeze
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
          find_all(RESULT_TITLES)
        end
      end
    end
  end
end
