require_relative "./error"

module Logout
  def logout
    begin
    profile =  @browser.find_element(css: '.btn-with-icon').click
    sleep 2
    rescue StandardError => e
      error(e, 'failed to logout/exit')
    end
  end
end