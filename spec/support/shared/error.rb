shared_examples_for 'Error' do

  context 'POST /v1/shorten' do

    it 'returns error status' do
      expect(call_api(params).status).to eq(response_code)
    end

    it_behaves_like 'ContentType'
    it_behaves_like 'ResponseBody'
    it_behaves_like 'LinkCreate!'
  end
end
