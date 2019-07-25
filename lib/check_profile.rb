require_relative "./error"

module CheckProfile
  def check_profile
    begin
    @browser.find_element(css: '.user-picture > img').click
    sleep 5
    @browser.find_element(css: '.not-found-view__content-title')
    rescue StandardError => e
      error(e, 'failed to find profile')
    end
  end
end