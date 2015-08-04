shared_examples_for 'Private Pub publish' do
  it 'should publish to PrivatePub' do
    expect(PrivatePub).to receive(:publish_to).with('/questions', anything)
    request
  end

  it 'should not publish to PrivatePub, params invalid' do
    expect(PrivatePub).to_not receive(:publish_to)
    invalid_params
  end
end