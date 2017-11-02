require 'spec_helper'

RSpec.describe Link, type: :model do
  it {should validate_presence_of(:url)}

  describe '.validations' do
    context 'invalid format' do
      let(:message) {'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'}

      it 'raises Link::FormatError with given message' do
        expect {Link.create(url: 'https://cite-urls', shortcode: 'cut')}
            .to raise_error(Link::FormatError, message)
      end
    end

    context 'shortcode doublicate' do
      let!(:link) {create(:link, url: 'https://cite-links', shortcode: 'cute')}
      let(:message) {'The the desired shortcode is already in use'}

      it 'raises Link::ExistError with given message' do
        expect {Link.create(url: 'https://new-links', shortcode: 'cute')}
            .to raise_error(Link::DuplicateError, message)
      end
    end
  end

  describe '.new_shortcode' do
    it 'receives generate method for ShortNameGenerator class with given arguments' do
      expect(ShortcodeGenerator).to receive(:generate).with(6)
      Link.new_shortcode
    end
  end

  describe 'private #shortcode_is_unique?' do
    context 'not unique' do
      let!(:link) {create(:link, url: 'https://cute-links', shortcode: 'cute')}
      let(:not_unique_link) {build(:link, url: 'https://new-links', shortcode: 'cute')}

      it 'returns false' do
        expect(not_unique_link.send(:shortcode_is_unique?)).to eq false
      end
    end

    context 'unique' do
      let!(:link) {create(:link, url: 'https://cute-links', shortcode: 'cute')}

      it 'returns true' do
        expect(link.send(:shortcode_is_unique?)).to eq true
      end
    end
  end

  describe 'private #set_shortcode' do
    context 'shortcode is not given' do
      let(:link) {build(:link, url: 'https://new-links', shortcode: '')}

      it 'generates  a valid shortcode for the given link' do
        link.save
        expect(link.shortcode).to match(/^[0-9a-zA-Z_]{6}$/)
      end
    end

    context 'shortcode is given' do
      let(:link) {build(:link, url: 'https://new-links', shortcode: 'cute')}

      it "doesn't generate a shortcode for the given link" do
        link.save
        expect(link.shortcode).to eq('cute')
      end
    end
  end
end
