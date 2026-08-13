# Hybrid Web + Mobile Automation Framework (Ruby)

A single RSpec framework that drives **both** browser (Selenium) and native
mobile (Appium) tests through one `DriverFactory.create_driver(platform)`
call. `appium_lib_core` builds its driver on top of the same
`Selenium::WebDriver` machinery the web driver uses (plus mobile locator
strategies like `:accessibility_id` and `:uiautomator`), so page objects
share the same `find_element`/`find_elements` calls regardless of platform.

## Stack

| Concern       | Tool                                |
|---------------|----------------------------------------|
| Web driver    | selenium-webdriver                      |
| Mobile driver | appium_lib_core (UiAutomator2 / XCUITest) |
| Test runner   | RSpec                                   |
| Task runner   | Rake                                    |

## Project layout

```
lib/hybrid_framework/
  config.rb                  # config/config.yml + HYBRID_* env overrides
  driver_factory.rb           # create_driver(:web | :android | :ios)
  pages/web/                  # BasePage, LoginPage, InventoryPage
  pages/mobile/                # BaseScreen, SettingsScreen
spec/
  spec_helper.rb
  web/login_spec.rb           # saucedemo.com
  mobile/settings_search_spec.rb  # Android Settings app (no APK needed)
```

## Prerequisites

- Ruby 3.1+, Bundler
- Chrome (for web tests)
- For mobile tests: Appium server (`npm i -g appium && appium`), an Android
  emulator/device, and `appium driver install uiautomator2`

## Setup

```bash
bundle install
```

## Running tests

```bash
# Web
bundle exec rake web

# Web, headless
HYBRID_WEB_HEADLESS=true bundle exec rake web

# Mobile (requires Appium server running on 127.0.0.1:4723)
bundle exec rake mobile
```

Any config key can be overridden via `HYBRID_<DOTTED_KEY_UPCASED>`, e.g.
`HYBRID_ANDROID_DEVICE_NAME`, `HYBRID_WEB_BASE_URL`.

## CI

`.github/workflows/ci.yml` runs the web suite headlessly on every push/PR.
Mobile tests require a real device/emulator + Appium server, so they're left
for local or device-farm execution (`bundle exec rake mobile`).
