require_relative './error'

# Org Check
module OrgCheck
  def org_check
    @browser.navigate.to 'https://ahoy.alliantsdev.com'
    @browser.find_element(css: '.tab-item').click
    sleep 1
    @browser.page_source.should include 'Organisations'
    @browser.page_source.should include 'New Organisation'
    @browser.page_source.should include 'Logo'

  rescue StandardError => e
    error(e, 'failed to load organisations')
  end
end
