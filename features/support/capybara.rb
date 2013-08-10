require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {debug: false})
end

Capybara.javascript_driver = :poltergeist

# Make mechanize available as well
require 'capybara/mechanize/cucumber'
