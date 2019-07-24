require_relative "./error"


module Login
  def login
    begin
    username =  @browser.find_element(id: 'field-email')
    username.send_keys(ENV['USERNAME'])

    password = @browser.find_element(id: 'field-password')
    password.send_keys(ENV['PASSWORD'])

    login_button = @browser.find_element(css: '.btn-action').click
    sleep 10
    @browser.find_element(css: '.fa-sign-out-alt > path')
    rescue StandardError => e
      error(e, 'failed to login')
    end
  end
end