require 'spec_helper'

describe Fasterer::AnalyzerVisitor do
  let(:analyzer) { instance_double(Fasterer::Analyzer) }
  let(:visitor) { Fasterer::AnalyzerVisitor.new(analyzer) }

  describe '#visit_call_node' do
    it 'dispatches to scan_method_calls' do
      result = Fasterer::Parser.parse('foo.bar')
      node = result.value.statements.body.first

      allow(analyzer).to receive(:scan_method_calls)
      visitor.visit_call_node(node)
      expect(analyzer).to have_received(:scan_method_calls).with(node)
    end
  end

  describe '#visit_def_node' do
    it 'dispatches to scan_method_definitions' do
      result = Fasterer::Parser.parse('def foo; end')
      node = result.value.statements.body.first

      allow(analyzer).to receive(:scan_method_definitions)
      visitor.visit_def_node(node)
      expect(analyzer).to have_received(:scan_method_definitions).with(node)
    end
  end

  describe '#visit_for_node' do
    it 'dispatches to scan_for_loop' do
      result = Fasterer::Parser.parse('for x in [1, 2]; end')
      node = result.value.statements.body.first

      allow(analyzer).to receive(:scan_for_loop)
      visitor.visit_for_node(node)
      expect(analyzer).to have_received(:scan_for_loop).with(node)
    end
  end

  describe '#visit_rescue_node' do
    it 'dispatches to scan_rescue' do
      result = Fasterer::Parser.parse("begin; rescue; end")
      rescue_node = result.value.statements.body.first.rescue_clause

      allow(analyzer).to receive(:scan_rescue)
      visitor.visit_rescue_node(rescue_node)
      expect(analyzer).to have_received(:scan_rescue).with(rescue_node)
    end
  end

  describe '#visit_lambda_node' do
    it 'dispatches to scan_method_calls' do
      result = Fasterer::Parser.parse('-> {}')
      node = result.value.statements.body.first

      allow(analyzer).to receive(:scan_method_calls)
      visitor.visit_lambda_node(node)
      expect(analyzer).to have_received(:scan_method_calls).with(node)
    end
  end
end
