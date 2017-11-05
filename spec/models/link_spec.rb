require 'spec_helper'

RSpec.describe Link, type: :model do
  it {should validate_presence_of(:url)}

  describe '.validations' do
    context 'valid attributes' do
      context 'shortcode params is given' do
        it 'saves a new link into the database' do
          expect {Link.create!(url: 'https://cite-urls', shortcode: 'cute')}
              .to change(Link, :count).by(1)
        end
      end

      context 'shortcode params is blank' do
        it 'saves a new link into the database' do
          expect {Link.create!(url: 'https://cite-urls', shortcode: '')}
              .to change(Link, :count).by(1)
        end
      end
    end

    context 'invalid format' do
      let(:message) {'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'}

      it 'raises Link::FormatError with given message' do
        expect {Link.create!(url: 'https://cite-urls', shortcode: 'cut')}
            .to raise_error(Link::FormatError, message)
      end
    end

    context 'shortcode doublicate' do
      let!(:link) {create(:link)}
      let(:message) {'The the desired shortcode is already in use'}

      it 'raises Link::ExistError with given message' do
        expect {Link.create!(url: 'https://new-links', shortcode: 'cute')}
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
      let!(:link) {create(:link)}
      let(:not_unique_link) {build(:link, url: 'https://new-links', shortcode: 'cute')}

      it 'returns false' do
        expect(not_unique_link.send(:shortcode_is_unique?)).to eq false
      end
    end

    context 'unique' do
      let!(:link) {create(:link)}

      it 'returns true' do
        expect(link.send(:shortcode_is_unique?)).to eq true
      end
    end
  end

  describe 'callback before_validations #set_shortcode' do
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

  describe '#increment_redirect_count!' do
    let!(:link) {create(:link)}
    it 'increments redirect count field for the link object' do
      link.increment_redirect_count!
      expect(link.redirect_count).to eq 1
    end
  end

  describe '#stats' do
    context 'redirect_count > 0' do
      let!(:link) {  create(:link, redirect_count: 2)}

      it 'returns hash' do
        expect(link.stats).to be_a(Hash)
      end

      it 'contains 3 key/value pairs' do
        expect(link.stats.size).to eq 3
      end

      it 'includes the start_date' do
        expect(link.stats[:start_date]).to eq link.created_at.iso8601
      end

      it 'includes the last_seen_date' do
        expect(link.stats[:last_seen_date]).to eq link.updated_at.iso8601
      end

      it 'includes the redirect_count' do
        expect(link.stats[:redirect_count]).to eq 2
      end
    end

    context 'redirect_count == 0' do
      let!(:link) { create(:link)}

      it 'returns hash' do
        expect(link.stats).to be_a(Hash)
      end

      it 'contains 2 key/value pairs' do
        expect(link.stats.size).to eq 2
      end

      it 'includes the start_date' do
        expect(link.stats[:start_date]).to eq link.created_at.iso8601
      end

      it 'includes the last_seen_date' do
        expect(link.stats[:last_seen_date]).to eq link.updated_at.iso8601
      end

      it "doesn't includ the redirect_count" do
        expect(link.stats[:redirect_count]).to be_nil
      end
    end
  end
end
