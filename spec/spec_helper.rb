require 'git'
Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
 config.include TestRepos
end
