ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Improvements on tests results
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def enable_omniauth_test_mode
    Omniauth.config.test_mode = true

    OmniAuth.config.mock_auth[:spotify] = nil
    OmniAuth.config.mock_auth[:default] = nil
    OmniAuth.config.mock_auth[:spotify] = OmniAuth::AuthHash.new({
      provider: 'spotify',
      uid: '123545'
      # etc.
    })

    OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new({
      provider: 'NULL',
      uid: 'askldjdjklsa',
      status: 'ERROR'
    })

  end
  # Add more helper methods to be used by all tests here...
end
