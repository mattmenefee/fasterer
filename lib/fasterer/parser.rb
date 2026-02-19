# frozen_string_literal: true

require 'prism'

module Fasterer
  class Parser
    def self.parse(ruby_code)
      Prism.parse(ruby_code)
    end
  end
end
