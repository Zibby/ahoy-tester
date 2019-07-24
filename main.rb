#!/usr/bin/env ruby

require "selenium-webdriver"
require "slack"
require_relative "./lib/check_profile"
require_relative "./lib/login"
require_relative "./lib/logout"

class AhoyTest
  attr_accessor :browser,:root_url

  include Login
  include CheckProfile
  include Logout

  def initialize
    @root_url = 'https://ahoy.alliantsdev.com'
    @browser = Selenium::WebDriver.for(
      :remote, 
      :url => "http://selenium-hub:4444/wd/hub",
      :desired_capabilities => {:browserName => "chrome"}
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
    steps = %w[login check_profile logout]
    steps.each do |step|
      puts 'in step loop'
      begin 
        TC.send(step)
      rescue
        TC.error(nil, "Error sending #{step}")
        return
      end
    end
  rescue
    next
  end
  puts 'sleeping'
  sleep 10
end