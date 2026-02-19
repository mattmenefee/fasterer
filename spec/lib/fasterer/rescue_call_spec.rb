require 'spec_helper'

describe Fasterer::RescueCall do
  let(:file_path) { RSpec.root.join('support', 'rescue_call', file_name) }

  let(:rescue_element) do
    parsed = Fasterer::Parser.parse(File.read(file_path))
    parsed.value.statements.body.first.rescue_clause
  end

  let(:rescue_call) { Fasterer::RescueCall.new(rescue_element) }

  describe 'plain rescue call' do
    let(:file_name) { 'plain_rescue.rb' }

    it 'should have no rescue classes' do
      expect(rescue_call.rescue_classes).to eq([])
    end
  end

  describe 'rescue call with class' do
    let(:file_name) { 'rescue_with_class.rb' }

    it 'should detect rescue class' do
      expect(rescue_call.rescue_classes).to eq([:NoMethodError])
    end
  end

  describe 'rescue call with class and variable' do
    let(:file_name) { 'rescue_with_class_and_variable.rb' }

    it 'should detect rescue class' do
      expect(rescue_call.rescue_classes).to eq([:NoMethodError])
    end
  end

  describe 'rescue call with variable' do
    let(:file_name) { 'rescue_with_variable.rb' }

    it 'should have no rescue classes' do
      expect(rescue_call.rescue_classes).to eq([])
    end
  end

  describe 'rescue call with multiple classes' do
    let(:file_name) { 'rescue_with_multiple_classes.rb' }

    it 'should detect all rescue classes' do
      expect(rescue_call.rescue_classes).to eq([:NoMethodError, :StandardError])
    end
  end

  describe 'rescue call with multiple classes and variable' do
    let(:file_name) { 'rescue_with_multiple_classes_and_variable.rb' }

    it 'should detect all rescue classes' do
      expect(rescue_call.rescue_classes).to eq([:NoMethodError, :StandardError])
    end
  end
end
