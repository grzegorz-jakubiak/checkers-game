# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in checkers-game.gemspec
gemspec

gem 'rake', '~> 12.0'

group :lint do
  gem 'rubocop', '~> 0.93.1', require: false
end
