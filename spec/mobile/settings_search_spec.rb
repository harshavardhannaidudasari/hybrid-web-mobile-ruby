require 'hybrid_framework/pages/mobile/settings_screen'

RSpec.describe 'Android Settings search', :mobile do
  let(:driver) { create_driver_for(:android) }

  after { driver.quit }

  it 'returns at least one result for "Wi-Fi"' do
    settings = HybridFramework::Pages::Mobile::SettingsScreen.new(driver)
    settings.open_search.search_for('Wi-Fi')

    expect(settings.results).not_to be_empty
  end
end
