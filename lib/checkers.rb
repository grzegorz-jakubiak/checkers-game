# frozen_string_literal: true

require 'matrix'
require 'observer'

require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'ai' => 'AI'
)
loader.setup
