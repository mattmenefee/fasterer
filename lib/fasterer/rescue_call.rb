# frozen_string_literal: true

require 'prism'

module Fasterer
  class RescueCall
    attr_reader :element
    attr_reader :rescue_classes

    def initialize(node)
      @element = node
      @rescue_classes = []
      set_rescue_classes
    end

    private

    def set_rescue_classes
      @rescue_classes = element.exceptions.filter_map do |exc|
        exc.name if exc.is_a?(Prism::ConstantReadNode)
      end
    end
  end
end
