require 'hybrid_framework/pages/mobile/bstack_sample_screen'

RSpec.describe 'iOS BrowserStack sample app text flow', :mobile do
  let(:driver) { create_driver_for(:ios) }

  after { driver.quit }

  it 'echoes the submitted text back as output' do
    screen = HybridFramework::Pages::Mobile::BstackSampleScreen.new(driver)
    screen.tap_text_button
    screen.submit_text('hello@browserstack.com')

    expect(screen.output_text).to eq('hello@browserstack.com')
  end
end
