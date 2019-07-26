#!/usr/bin/env ruby
# frozen_string_literal: true

require 'selenium-webdriver'
require 'slack'
require 'yaml'

# Master Class
class WebsiteTest
  def initialize
    load_yaml
    @browser = choose_browser
    activate
  end

  def activate
    if @config['testmode'] == true
      runsteps
    else
      loop do
        runsteps
        sleep 30
      end
    end
  end

  def choose_browser
    if @config['local'] == true
      puts 'using local chrome driver'
      Selenium::WebDriver.for(:chrome)
    else
      puts 'using selenium hub'
      Selenium::WebDriver.for(
        :remote,
        url: 'http://selenium-hub:4444/wd/hub',
        desired_capabilities: { browserName: 'chrome' }
      )
    end
  end

  def load_yaml
    yaml = YAML.load_file(ARGV[0])
    @steps = yaml['steps']
    @config = yaml['config']
    init_slack if @config['slack']
  end

  def runsteps
    @steps.each do |step|
      @step_name = step.keys.first
      puts "step: #{@step_name}"
      actions = step[@step_name]['actions']
      actions.each do |action|
        runaction(action)
      end
    end
  end

  def runaction(action)
    action_type = action.keys.first
    @action_arg = action[action_type]
    begin
      send(action_type)
    rescue StandardError => e
      alert_me(e, action_type, @action_arg) unless action_type == 'send_keys'
    end
  end

  def alert_me(err, action_type, action_arg)
    puts "unable to process #{action_type} with #{action_arg} because #{err}"
    send_slack(err, action_type, action_arg) if @config['slack']
  end

  def init_slack
    Slack.configure do |config|
      config.token = @config['slack']['key']
    end
    @slack = Slack::Web::Client.new
  end

  def send_slack(err, action_type, action_arg)
    @slack.chat_postMessage(
      channel: @config['slack']['channel'],
      text: "unable to process #{action_type} with #{action_arg} because #{err}",
      as_user: true
    )
  end

  ## Action Types ##
  def navigate_to
    puts "navigating to: #{@action_arg}"
    @browser.navigate.to(@action_arg)
  end

  def find_element
    puts "finding element: #{@action_arg}"
    case @action_arg['class']
    when 'css'
      @element = @browser.find_element(css: @action_arg['value'])
    when 'id'
      @element = @browser.find_element(id: @action_arg['value'])
    when 'name'
      @element = @browser.find_element(name: @action_arg['value'])
    end
  end

  def send_keys
    puts "sending keys to #{@element}"
    @element.send_keys(@action_arg)
  end

  def click
    puts "clicking: #{@element}"
    @element.click
  end

  def hit_enter
    @element.submit
  end

  def validate_text
    puts @action_arg
    sleep 1
    unless @action_arg.all? { |d| @browser.page_source.include? d }
      puts 'missing text'
    end
    puts 'text validated'
  end
end

WebsiteTest.new
puts 'test_complete'
