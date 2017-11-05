shared_examples_for 'Created' do

  it 'returns 201 status' do
    expect(call_api(params).status).to eq(201)
  end

  it_behaves_like 'ContentType'
end
