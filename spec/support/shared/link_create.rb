shared_examples_for 'LinkCreate!' do
  it 'receives create! method for Link class with given arguments' do
    expect(Link).to receive(:create!).with(params)
    call_api(params)
  end
end

