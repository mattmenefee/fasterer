# frozen_string_literal: true

require 'fasterer/offense'

module Fasterer
  module Offensive
    attr_accessor :offense

    def offensive?
      !!offense
    end

    alias_method :offense_detected?, :offensive?

    private

    def add_offense(offense_name)
      self.offense = Fasterer::Offense.new(offense_name, element.location.start_line)
    end

    def check_offense
      fail NotImplementedError
    end
  end
end
