require 'hybrid_framework/config'
require 'hybrid_framework/pages/web/login_page'

RSpec.describe 'SauceDemo login', :web do
  let(:driver) { create_driver_for(:web) }

  after { driver.quit }

  it 'logs a standard user in to the inventory page' do
    driver.navigate.to(HybridFramework::Config.get('web.base_url'))
    inventory = HybridFramework::Pages::Web::LoginPage.new(driver).login_as('standard_user', 'secret_sauce')

    expect(inventory.page_title).to eq('Products')
    expect(inventory.item_count).to be > 0
  end

  it 'shows an error for a locked out user' do
    driver.navigate.to(HybridFramework::Config.get('web.base_url'))
    login_page = HybridFramework::Pages::Web::LoginPage.new(driver)
    login_page.submit_login('locked_out_user', 'secret_sauce')

    expect(login_page.error_message).to include('locked out')
  end
end
