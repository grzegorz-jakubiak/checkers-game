# frozen_string_literal: true

require 'matrix'

require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'ai' => 'AI'
)
loader.setup
