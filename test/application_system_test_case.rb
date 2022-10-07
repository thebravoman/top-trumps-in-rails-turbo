require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  # using firefox, because :chrome gives me this weird error:
  # /Users/hidr0/.rvm/gems/ruby-2.7.4/gems/webdrivers-5.1.0/lib/webdrivers/network.rb:19:in `get':
  # Net::HTTPServerException: 404 "Not Found" with
  # https://chromedriver.storage.googleapis.com/106.0.5249.61/chromedriver_mac64_m1.zip (Webdrivers::NetworkError)
  driven_by :selenium, using: :firefox
end
