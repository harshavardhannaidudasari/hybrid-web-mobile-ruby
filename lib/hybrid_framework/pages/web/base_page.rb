require 'selenium-webdriver'

module HybridFramework
  module Pages
    module Web
      class BasePage
        DEFAULT_TIMEOUT = 10

        def initialize(driver)
          @driver = driver
        end

        def open(url)
          @driver.navigate.to(url)
        end

        private

        def find(locator)
          wait.until do
            element = @driver.find_element(*locator)
            element if element.displayed?
          end
        end

        def click(locator)
          wait.until do
            element = @driver.find_element(*locator)
            element if element.displayed? && element.enabled?
          end.click
        end

        def type(locator, text)
          element = find(locator)
          element.clear
          element.send_keys(text)
        end

        def wait
          Selenium::WebDriver::Wait.new(
            timeout: DEFAULT_TIMEOUT,
            ignore: [Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::StaleElementReferenceError]
          )
        end
      end
    end
  end
end
