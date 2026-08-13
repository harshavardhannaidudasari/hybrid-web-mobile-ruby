require 'selenium-webdriver'
require 'appium_lib_core'
require_relative 'config'

module HybridFramework
  # Builds either a plain Selenium driver (web) or an Appium session
  # (mobile) behind one call. appium_lib_core patches its driver with the
  # same find_element/find_elements surface Selenium exposes, plus mobile
  # locator strategies (:accessibility_id, :uiautomator) - so page objects
  # never need to know which platform they're driving.
  module DriverFactory
    module_function

    def create_driver(platform)
      case platform.to_sym
      when :web then create_web_driver
      when :android then create_android_driver
      when :ios then create_ios_driver
      else raise ArgumentError, "Unsupported platform: #{platform}"
      end
    end

    def create_web_driver
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless=new') if Config.get('web.headless', false).to_s == 'true'
      options.add_argument('--window-size=1400,1000')

      driver = Selenium::WebDriver.for(:chrome, options: options)
      driver.manage.timeouts.implicit_wait = 5
      driver
    end

    def create_android_driver
      core = Appium::Core.for(
        appium_lib: { server_url: Config.get('mobile.appium_server_url') },
        caps: {
          platformName: 'Android',
          'appium:automationName' => 'UiAutomator2',
          'appium:deviceName' => Config.get('android.device_name'),
          'appium:appPackage' => Config.get('android.app_package'),
          'appium:appActivity' => Config.get('android.app_activity'),
          'appium:noReset' => true,
          'appium:newCommandTimeout' => Config.get('mobile.new_command_timeout', 120)
        }
      )
      core.start_driver
    end

    def create_ios_driver
      core = Appium::Core.for(
        appium_lib: { server_url: Config.get('mobile.appium_server_url') },
        caps: {
          platformName: 'iOS',
          'appium:automationName' => 'XCUITest',
          'appium:deviceName' => Config.get('ios.device_name'),
          'appium:platformVersion' => Config.get('ios.platform_version'),
          'appium:bundleId' => Config.get('ios.bundle_id'),
          'appium:noReset' => true,
          'appium:newCommandTimeout' => Config.get('mobile.new_command_timeout', 120)
        }
      )
      core.start_driver
    end
  end
end
