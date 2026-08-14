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
  mobile/ios_sample_spec.rb   # iOS, via BrowserStack App Automate
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

# Mobile - Android (requires Appium server running on 127.0.0.1:4723)
bundle exec rake mobile

# Mobile - iOS (requires BrowserStack credentials, see below)
bundle exec rake ios
```

Any config key can be overridden via `HYBRID_<DOTTED_KEY_UPCASED>`, e.g.
`HYBRID_ANDROID_DEVICE_NAME`, `HYBRID_WEB_BASE_URL`.

`rake mobile` only runs the local-Appium Android suite (`spec/mobile/**/*_spec.rb`,
excluding `ios_*_spec.rb`); `rake ios` runs just the BrowserStack iOS spec
(`spec/mobile/ios_*_spec.rb`). They're kept separate because they target
different backends and credentials.

## iOS (BrowserStack App Automate)

Local iOS simulation isn't possible on this machine, so the iOS test runs
against [BrowserStack App Automate](https://www.browserstack.com/app-automate)
- a cloud farm of real iOS devices - instead of a local Mac/simulator. It
drives BrowserStack's own public demo app, **BStackSampleApp**, tapping
"Text Button", entering an email into "Text Input", and asserting "Text
Output" echoes it back.

### Prerequisites

- A BrowserStack account (username + access key from
  <https://www.browserstack.com/accounts/settings>)
- The BStackSampleApp `.ipa` uploaded to your BrowserStack account (one-time,
  not something you build yourself - it's BrowserStack's own official sample
  app):

  ```bash
  curl -u "$BROWSERSTACK_USERNAME:$BROWSERSTACK_ACCESS_KEY" -X POST "https://api-cloud.browserstack.com/app-automate/upload" \
    -F "url=https://www.browserstack.com/app-automate/sample-apps/ios/BStackSampleApp.ipa"
  ```

  This returns `{"app_url":"bs://<hash>"}` - that `bs://...` value is your
  `BROWSERSTACK_APP_ID`.

### Required environment variables

| Variable                 | Description                                         |
|---------------------------|------------------------------------------------------|
| `BROWSERSTACK_USERNAME`   | BrowserStack username                                 |
| `BROWSERSTACK_ACCESS_KEY` | BrowserStack access key                                |
| `BROWSERSTACK_APP_ID`     | `bs://...` id from the upload step above               |
| `BROWSERSTACK_HUB_URL`    | Optional - defaults to `https://hub-cloud.browserstack.com/wd/hub` |

These plain `BROWSERSTACK_*` names (BrowserStack's own documented
convention) are read directly; `browserstack.*` keys in `config/config.yml`
(device name, platform version, hub URL, project/build name) can still be
overridden the usual way via `HYBRID_BROWSERSTACK_*`. Credentials and the
app id are never stored in `config.yml`.

### Running

```bash
BROWSERSTACK_USERNAME=... BROWSERSTACK_ACCESS_KEY=... BROWSERSTACK_APP_ID=bs://... \
  bundle exec rake ios

# or, to run just this spec directly:
BROWSERSTACK_USERNAME=... BROWSERSTACK_ACCESS_KEY=... BROWSERSTACK_APP_ID=bs://... \
  bundle exec rspec spec/mobile/ios_sample_spec.rb
```

## CI

`.github/workflows/ci.yml` runs the web suite headlessly on every push/PR.
Mobile tests require a real device/emulator + Appium server (Android) or
BrowserStack credentials (iOS), so they're left for local or device-farm
execution (`bundle exec rake mobile`, `bundle exec rake ios`).
