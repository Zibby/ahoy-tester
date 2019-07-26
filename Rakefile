# frozen_string_literal: true

task default: %w[test]

task :test do
  sh 'rubocop'
  ruby './main.rb ./testing.yml'
end

task :start do
  ruby 'main.rb ./config.yml'
end
