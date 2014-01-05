
source 'https://rubygems.org'

gemspec

gem 'rake'
gem 'bacon'
gem 'muack'

gem 'bond'
gem 'hirb'

platforms :ruby do
  gem 'readline_buffer'
end

platforms :rbx do
  gem 'rubysl-singleton' # used in rake
  gem 'rubysl-readline'  # we need readline extension
end
