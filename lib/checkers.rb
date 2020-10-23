# frozen_string_literal: true

require 'matrix'
require 'observer'
require 'forwardable'

require 'ruby2d'
require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'ai' => 'AI',
  'gui' => 'GUI'
)
loader.setup
