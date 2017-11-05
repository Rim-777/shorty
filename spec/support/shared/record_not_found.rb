shared_examples_for 'RecordNotFound' do

  it 'returns 404 status' do
    expect(call_api(params).status).to eq(404)
  end

  it_behaves_like 'ContentType'
  it_behaves_like 'ResponseBody'
end
