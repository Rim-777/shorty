shared_examples_for 'ContentType' do

  it 'contains application/json as the Content-Type header' do
    expect(call_api(params).headers["Content-Type"])
        .to eq 'application/json'
  end
end
