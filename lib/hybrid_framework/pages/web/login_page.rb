require_relative 'base_page'
require_relative 'inventory_page'

module HybridFramework
  module Pages
    module Web
      class LoginPage < BasePage
        USERNAME = [:id, 'user-name'].freeze
        PASSWORD = [:id, 'password'].freeze
        LOGIN_BUTTON = [:id, 'login-button'].freeze
        ERROR_MESSAGE = [:css, "[data-test='error']"].freeze

        def login_as(user, password)
          submit_login(user, password)
          InventoryPage.new(@driver)
        end

        def submit_login(user, password)
          type(USERNAME, user)
          type(PASSWORD, password)
          click(LOGIN_BUTTON)
        end

        def error_message
          find(ERROR_MESSAGE).text
        end
      end
    end
  end
end
