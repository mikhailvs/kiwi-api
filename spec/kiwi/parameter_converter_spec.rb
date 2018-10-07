describe Kiwi::API::ParameterConverter do
  it 'converts parameters' do
    converter = described_class.new do
      convert(:a) { |v| { converted_a: "'#{v}' is the value" } }
      convert(:b) { |v| v }
    end

    params = {
      a: SecureRandom.hex,
      b: {
        ba: SecureRandom.hex,
        bb: SecureRandom.hex
      }
    }

    converted = converter.process(params)

    expect(converted[:converted_a]).to eq("'#{params[:a]}' is the value")
    expect(converted.keys.length).to eq(3)
    expect(converted.slice(:ba, :bb)).to eq(params[:b])
  end
end
