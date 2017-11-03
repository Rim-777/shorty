require 'spec_helper'

describe Api::V1::Links, type: :api do

  describe '/shorten' do
    let(:url) {'https//cute-links.com'}

    context 'shortcode is not given' do
      context 'POST /v1/shorten' do
        it 'returns 201 status' do
          expect(call_api({url: url}).status).to eq(201)
        end

        it 'contains application/json as the Content-Type header' do
          expect(call_api({url: url}).headers["Content-Type"]).to eq 'application/json'
        end

        it 'returns a shortcode matched to a given pattern' do
          expect(JSON.parse(call_api({url: url}).body)['shortcode']).to match(/^[0-9a-zA-Z_]{6}$/)
        end

        it 'receives generate method for ShortNameGenerator class with given arguments' do
          expect(Link).to receive(:create!).with(url: url, shortcode: "")
          call_api({url: url, shortcode: ''})
        end
      end
    end

    context 'some shortcode is given' do
      context 'shortcode is unique' do

        let(:shortcode) {'cute'}

        context 'POST /v1/shorten' do

          it 'returns 201 status' do
            expect(call_api({url: url, shortcode: shortcode}).status).to eq(201)
          end

          it 'contains application/json as the Content-Type header' do
            expect(call_api({url: url, shortcode: shortcode}).headers["Content-Type"]).to eq 'application/json'
          end

          it 'returns shortcode matched a given pattern' do
            expect(JSON.parse(call_api({url: url, shortcode: shortcode}).body)['shortcode']).to eq shortcode
          end

          it 'receives generate method for ShortNameGenerator class with given arguments' do
            expect(Link).to receive(:create!).with(url: url, shortcode: shortcode)
            call_api({url: url, shortcode: shortcode})
          end
        end
      end

      context 'shortcode is unique' do
        let(:shortcode) {'cute'}
        let(:response_body) {{'shortcode' => 'cute'}}
        context 'POST /v1/shorten' do

          it 'returns 201 status' do
            expect(call_api({url: url, shortcode: shortcode}).status).to eq(201)
          end

          it 'contains application/json as the Content-Type header' do
            expect(call_api({url: url, shortcode: shortcode}).headers["Content-Type"]).to eq 'application/json'
          end

          it 'returns shortcode matched a given pattern' do
            expect(JSON.parse(call_api({url: url, shortcode: shortcode}).body)).to eq response_body
          end

          it 'receives generate method for ShortNameGenerator class with given arguments' do
            expect(Link).to receive(:create!).with(url: url, shortcode: shortcode)
            call_api({url: url, shortcode: shortcode})
          end
        end
      end

      context 'shortcode is not unique' do
        let!(:link) {create(:link, url: 'https//cute-links.com', shortcode: 'cute')}

        let(:shortcode) {'cute'}

        let(:response_body) {{'error' => 'The the desired shortcode is already in use'}}

        context 'POST /v1/shorten' do

          it 'returns 409 status' do
            expect(call_api({url: url, shortcode: shortcode}).status).to eq(409)
          end

          it 'contains application/json as the Content-Type header' do
            expect(call_api({url: url, shortcode: shortcode}).headers["Content-Type"]).to eq 'application/json'
          end

          it 'returns shortcode matched a given pattern' do
            expect(JSON.parse(call_api({url: url, shortcode: shortcode}).body)).to eq response_body
          end

          it 'receives generate method for ShortNameGenerator class with given arguments' do
            expect(Link).to receive(:create!).with(url: url, shortcode: shortcode)
            call_api({url: url, shortcode: shortcode})
          end
        end
      end

      context 'shortcode has a forbidden format' do

        let(:shortcode) {'cut'}

        let(:response_body) {{'error' => 'The shortcode fails to meet the following regexp: ^[0-9a-zA-Z_]{4,}$'}}

        context 'POST /v1/shorten' do

          it 'returns 422 status' do
            expect(call_api({url: url, shortcode: shortcode}).status).to eq(422)
          end

          it 'contains application/json as the Content-Type header' do
            expect(call_api({url: url, shortcode: shortcode}).headers["Content-Type"])
                .to eq 'application/json'
          end

          it 'returns shortcode matched a given pattern' do
            expect(JSON.parse(call_api({url: url, shortcode: shortcode}).body))
                .to eq response_body
          end

          it 'receives generate method for ShortNameGenerator class with given arguments' do
            expect(Link).to receive(:create!).with(url: url, shortcode: shortcode)
            call_api({url: url, shortcode: shortcode})
          end
        end
      end
    end

    context 'missing url' do
      let(:shortcode) {'cute'}
      let(:url) {''}

      let(:response_body) {{'error' => "Validation failed: Url can't be blank"}}

      context 'POST /v1/shorten' do

        it 'returns 400 status' do
          expect(call_api({url: url, shortcode: shortcode}).status).to eq(400)
        end

        it 'contains application/json as the Content-Type header' do
          expect(call_api({url: url, shortcode: shortcode}).headers["Content-Type"])
              .to eq 'application/json'
        end

        it 'returns shortcode matched a given pattern' do
          expect(JSON.parse(call_api({url: url, shortcode: shortcode}).body))
              .to eq response_body
        end

        it 'receives generate method for ShortNameGenerator class with given arguments' do
          expect(Link).to receive(:create!).with(url: url, shortcode: shortcode)
          call_api({url: url, shortcode: shortcode})
        end
      end
    end
  end

  describe '/shortcode' do
    let(:shortcode) {'cute'}
    context 'required link exists in the database' do
      let!(:link) {create(:link, url: 'https://cite-urls.com', shortcode: 'cute')}

      context 'GET /v1/shortcode' do

        it 'returns 302 status' do
          expect(call_api({shortcode: shortcode}).status).to eq(302)
        end

        it 'contains application/json as the Content-Type header' do
          expect(call_api({shortcode: shortcode}).headers["Content-Type"]).to eq 'application/json'
        end

        it 'returns link url as a location header' do
          expect(call_api({shortcode: shortcode}).headers['Location']).to eq link.url
        end
      end
    end
  end
end
