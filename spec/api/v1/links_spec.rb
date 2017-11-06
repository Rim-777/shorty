require 'spec_helper'

describe Api::V1::Links, type: :api do

  describe '/shorten' do
    let(:url) {'https//cute-links.com'}

    context 'shortcode is blank' do
      let(:params) {{url: url, shortcode: ''}}

      context 'POST /v1/shorten' do
        it_behaves_like 'LinkCreate!'
        it_behaves_like 'Created'

        it 'returns a shortcode matched to the given pattern' do
          expect(JSON.parse(call_api({url: url}).body)['shortcode'])
              .to match(/^[0-9a-zA-Z_]{6}$/)
        end
      end
    end

    context 'shortcode is given' do
      let(:params) {{url: url, shortcode: 'cute'}}

      context 'shortcode is unique' do
        let(:response_body) {{'shortcode' => 'cute'}}

        context 'POST /v1/shorten' do
          it_behaves_like 'LinkCreate!'
          it_behaves_like 'Created'
          it_behaves_like 'ResponseBody'
        end
      end

      context 'shortcode is not unique' do
        let!(:link) {create(:link, url: 'https//cute-links.com', shortcode: 'cute')}
        let(:params) {{url: url, shortcode: 'cute'}}
        let(:response_body) {{'error' => 'The the desired shortcode is already in use'}}

        it_behaves_like 'Error' do
          let(:response_code) {409}
        end
      end

      context 'shortcode has a forbidden format' do
        let(:params) {{url: url, shortcode: 'cut'}}

        let(:response_body) do
          {'error' => 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'}
        end

        it_behaves_like 'Error' do
          let(:response_code) {422}
        end
      end
    end

    context 'missing url' do
      let(:params) {{url: '', shortcode: 'cute'}}
      let(:response_body) {{'error' => "Validation failed: Url can't be blank"}}

      it_behaves_like 'Error' do
        let(:response_code) {400}
      end
    end
  end

  describe '/shortcode' do
    let(:params) {{shortcode: 'cute'}}

    context 'required link exists in the database' do
      let!(:link) {create(:link, url: 'https://cite-urls.com', shortcode: 'cute')}

      context 'GET /v1/shortcode' do

        it 'returns 302 status' do
          expect(call_api(params).status).to eq(302)
        end

        it_behaves_like 'ContentType'

        it 'returns link url as a location header' do
          expect(call_api(params).headers['Location']).to eq link.url
        end
      end
    end

    context "required link doesn't exists in the database" do
      let(:response_body) {{'error' => 'The shortcode cannot be found in the system'}}

      context 'GET /v1/shortcode' do
        it_behaves_like 'RecordNotFound'
      end
    end
  end

  describe '/shortcode/stats' do
    let(:params) {{shortcode: 'cute'}}

    context 'required link exists in the database' do
      let!(:link) do
        create(:link, url: 'https://cite-urls.com', shortcode: 'cute', redirect_count: 2)
      end

      context 'with the field redirect_count' do

        let(:response_body) do
          {
              'start_date' => link.created_at.iso8601,
              'last_seen_date' => link.updated_at.iso8601,
              'redirect_count' => 2
          }
        end

        it_behaves_like 'ValidShortcodeStats'
      end

      context 'without the field redirect_count' do
        let!(:link) do
          create(:link, url: 'https://cite-urls.com', shortcode: 'cute', redirect_count: 0)
        end

        let(:response_body) do
          {
              'start_date' => link.created_at.iso8601,
              'last_seen_date' => link.updated_at.iso8601
          }
        end

        it_behaves_like 'ValidShortcodeStats'
      end
    end

    context "required link doesn't exists in the database" do
      let(:response_body) {{'error' => 'The shortcode cannot be found in the system'}}

      context 'GET /v1/shortcode/stats' do
        it_behaves_like 'RecordNotFound'
      end
    end
  end
end
