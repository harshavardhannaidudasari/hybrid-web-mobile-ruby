require 'selenium-webdriver'

module HybridFramework
  module Pages
    module Mobile
      class BaseScreen
        DEFAULT_TIMEOUT = 15

        def initialize(driver, timeout: self.class::DEFAULT_TIMEOUT)
          @driver = driver
          @timeout = timeout
        end

        def find_all(locator)
          wait.until do
            elements = @driver.find_elements(*locator)
            elements unless elements.empty?
          end
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
            timeout: @timeout,
            ignore: [Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::StaleElementReferenceError]
          )
        end
      end
    end
  end
end
