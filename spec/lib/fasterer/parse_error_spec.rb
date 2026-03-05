require 'spec_helper'
require 'tempfile'

describe Fasterer::Analyzer do
  describe 'parse error behavior' do
    let(:test_file) { Tempfile.new(['test', '.rb']) }

    after { test_file.unlink }

    it 'raises ParseError for invalid Ruby code' do
      test_file.write('[]*/sa*()')
      test_file.flush

      analyzer = Fasterer::Analyzer.new(test_file.path)
      expect { analyzer.scan }.to raise_error(Fasterer::ParseError)
    end

    it 'includes the error message from Prism' do
      test_file.write('def')
      test_file.flush

      analyzer = Fasterer::Analyzer.new(test_file.path)
      expect { analyzer.scan }.to raise_error(
        Fasterer::ParseError, /expected/i
      )
    end

    it 'does not raise for valid Ruby code' do
      test_file.write('puts "hello"')
      test_file.flush

      analyzer = Fasterer::Analyzer.new(test_file.path)
      expect { analyzer.scan }.not_to raise_error
    end
  end
end
