require_relative './error'

# Logout Check
module Logout
  def logout
    @browser.find_element(css: '.btn-with-icon').click
    sleep 2

  rescue StandardError => e
    error(e, 'failed to logout/exit')
  end
end
