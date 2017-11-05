shared_examples_for 'ValidShortcodeStats' do

  context 'GET /v1/shortcode/stats' do

    it 'returns 200 status' do
      expect(call_api(params).status).to eq(200)
    end

    it_behaves_like 'ContentType'

    it_behaves_like 'ResponseBody'
  end
end
