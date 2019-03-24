RSpec.describe Base16::Builder::SchemesCollection do
  before do
    stub_const("Base16::Builder::SCHEMES_DIR", File.join(support_dir, "schemes"))
  end

  describe "#initialize" do
    it "builds a collection of 'Base16::Builder::Scheme' objects" do
      scheme_file = File.join(Base16::Builder::SCHEMES_DIR, "default-dark.yaml")
      collection = described_class.new([scheme_file])

      expect(collection.first).to be_an_instance_of(Base16::Builder::Scheme)
    end
  end
end
