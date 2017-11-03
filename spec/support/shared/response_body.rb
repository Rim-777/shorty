shared_examples_for 'ResponseBody' do
  it 'returns the expected body' do
    expect(call_api(params).body)
        .to eq response_body.to_json
  end
end
