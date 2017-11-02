require 'spec_helper'

RSpec.describe ShortcodeGenerator do
  describe '.generate' do
    it 'returns a string' do
      expect(ShortcodeGenerator.generate(6)).to be_a(String)
    end

    it 'returns a string with given size of characters' do
      expect(ShortcodeGenerator.generate(6).size).to eq 6
    end

    it 'returns a string which is match a pattern' do
      expect(ShortcodeGenerator.generate(6)).to match(/^[0-9a-zA-Z_]{6}$/)
    end
  end
end
