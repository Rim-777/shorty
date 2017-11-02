require 'spec_helper'

RSpec.describe Link, type: :model do

  describe '.validations' do
    context 'invalid format' do
      let(:message) {'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'}

      it 'raises Link::FormatError with given message' do
        expect {Link.create(url: 'https://cite-urls', shortcode: 'cut')}.to raise_error(Link::FormatError, message)
      end
    end

    context 'shortcode doublicate' do
      let!(:link) {create(:link, url: 'https://cite-links', shortcode: 'cute')}
      let(:message) {'The the desired shortcode is already in use'}

      it 'raises Link::ExistError with given message' do
        expect {Link.create(url: 'https://new-links', shortcode: 'cute')}.to raise_error(Link::DuplicateError, message)
      end
    end
  end
end
