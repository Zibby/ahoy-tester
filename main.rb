#!/usr/bin/env ruby

require 'selenium-webdriver'
require 'slack'
# Load all files from lib
require 'require_all'
require_all './lib'

# Arh Matey
class AhoyTest
  attr_accessor :browser, :root_url

  include Login
  include CheckProfile
  include Logout
  include OrgCheck

  def initialize
    @root_url = 'https://ahoy.alliantsdev.com'
    @browser = Selenium::WebDriver.for(
      :remote,
      url: 'http://selenium-hub:4444/wd/hub',
      desired_capabilities: { browserName: 'chrome' }
    )
  end
end

puts 'sleeping'
sleep 20
puts 'building test class'
TC = AhoyTest.new
sleep 4
puts 'browsing to root url'
TC.browser.navigate.to TC.root_url
loop do
  begin
    steps = %w[login check_profile org_check logout]
    steps.each do |step|
      puts 'in step loop'
      begin
        TC.send(step)
      rescue StandardError => e
        TC.error(e, "Error sending #{step}")
        break
      end
    end
  rescue StandardError => e
    TC.error(e, 'Undefined Error')
    next
  end
  puts 'sleeping'
  sleep 10
end
