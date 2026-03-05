# frozen_string_literal: true

require 'prism'
require 'fasterer/method_definition'
require 'fasterer/method_call'
require 'fasterer/rescue_call'
require 'fasterer/offense_collector'
require 'fasterer/parser'
require 'fasterer/scanners/method_call_scanner'
require 'fasterer/scanners/rescue_call_scanner'
require 'fasterer/scanners/method_definition_scanner'

module Fasterer
  class ParseError < StandardError; end

  class Analyzer
    attr_reader :file_path
    alias_method :path, :file_path

    def initialize(file_path)
      @file_path = file_path.to_s
      @file_content = File.read(file_path)
    end

    def scan
      result = Fasterer::Parser.parse(@file_content)

      if result.failure?
        error = result.errors.first
        raise Fasterer::ParseError, error.message
      end

      visitor = AnalyzerVisitor.new(self)
      result.value.accept(visitor)
    end

    def errors
      @errors ||= Fasterer::OffenseCollector.new
    end

    def scan_method_definitions(node)
      scanner = MethodDefinitionScanner.new(node)
      errors.push(scanner.offense) if scanner.offense_detected?
    end

    def scan_method_calls(node)
      scanner = MethodCallScanner.new(node)
      errors.push(scanner.offense) if scanner.offense_detected?
    end

    def scan_for_loop(node)
      errors.push(Fasterer::Offense.new(:for_loop_vs_each, node.location.start_line))
    end

    def scan_rescue(node)
      scanner = RescueCallScanner.new(node)
      errors.push(scanner.offense) if scanner.offense_detected?
    end
  end

  class AnalyzerVisitor < Prism::Visitor
    def initialize(analyzer)
      @analyzer = analyzer
    end

    def visit_call_node(node)
      @analyzer.scan_method_calls(node)
      super
    end

    def visit_def_node(node)
      @analyzer.scan_method_definitions(node)
      super
    end

    def visit_for_node(node)
      @analyzer.scan_for_loop(node)
      super
    end

    def visit_rescue_node(node)
      @analyzer.scan_rescue(node)
      super
    end

    def visit_lambda_node(node)
      @analyzer.scan_method_calls(node)
      super
    end
  end
end
