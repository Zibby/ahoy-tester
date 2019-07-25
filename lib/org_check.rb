require_relative './error'

# Org Check
module OrgCheck
  def org_check
    @browser.navigate.to 'https://ahoy.alliantsdev.com'
    @browser.find_element(css: '.tab-item').click
    sleep 1

    desirables = %w[Organisations logo Name Actions]

    unless desirables.all { |d| browser.page_source.include? d }
      error(nil, 'org page content wrong')
    end
  rescue StandardError => e
    error(e, 'failed to load organisations')
  end
end
