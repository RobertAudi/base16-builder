RSpec.describe Base16::Builder do
  it "has a version number" do
    expect(Base16::Builder::VERSION).to_not be_nil
  end

  describe Base16::Builder::Error do
    it { expect(described_class.new).to be_a_kind_of(Exception) }
  end
end
