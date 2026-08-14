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
      driver = core.start_driver
      # appium:appPackage/appActivity alone don't reliably foreground a
      # pre-installed system app like Settings on every UiAutomator2
      # version - activate it explicitly so tests don't start on the home
      # screen.
      driver.execute_script(
        'mobile: startActivity',
        { intent: "#{Config.get('android.app_package')}/#{Config.get('android.app_activity')}" }
      )
      driver
    end

    # iOS runs against BrowserStack App Automate (a cloud real-device farm)
    # rather than a local Mac/simulator, which this Windows machine can't
    # provide. See README "iOS (BrowserStack App Automate)" for setup.
    def create_ios_driver
      core = Appium::Core.for(
        appium_lib: { server_url: browserstack_setting('BROWSERSTACK_HUB_URL', 'browserstack.hub_url') },
        caps: {
          platformName: 'iOS',
          'appium:deviceName' => Config.get('browserstack.device_name'),
          'appium:platformVersion' => Config.get('browserstack.platform_version'),
          'appium:app' => browserstack_setting('BROWSERSTACK_APP_ID', 'browserstack.app_id'),
          'bstack:options' => {
            userName: browserstack_setting('BROWSERSTACK_USERNAME', 'browserstack.username'),
            accessKey: browserstack_setting('BROWSERSTACK_ACCESS_KEY', 'browserstack.access_key'),
            projectName: Config.get('browserstack.project_name'),
            buildName: Config.get('browserstack.build_name'),
            sessionName: 'iOS BrowserStack sample app text flow',
            debug: true
          }
        }
      )
      core.start_driver
    end

    def browserstack_setting(env_name, config_path)
      Config.get_with_env_alias(env_name, config_path)
    end
  end
end
