require_relative 'base_page'

module HybridFramework
  module Pages
    module Web
      class InventoryPage < BasePage
        PAGE_TITLE = [:class, 'title'].freeze
        INVENTORY_ITEMS = [:class, 'inventory_item'].freeze

        def page_title
          find(PAGE_TITLE).text
        end

        def item_count
          @driver.find_elements(*INVENTORY_ITEMS).size
        end
      end
    end
  end
end
