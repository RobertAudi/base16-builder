RSpec.describe Base16::Builder do
  it "has a version number" do
    expect(described_class::VERSION).to_not be_nil
  end

  describe Base16::Builder::Error do
    it { expect(described_class.new).to be_a_kind_of(Exception) }
  end

  describe ".schemes_dir" do
    before do
      stub_const("#{described_class}::SCHEMES_DIR", File.join(support_dir, "schemes"))
    end

    it "returns the path to the schemes directory" do
      expect(described_class.schemes_dir).to eq(described_class::SCHEMES_DIR)
    end

    it "checks the 'BASE16_BUILDER_SCHEMES_DIR' environment variable" do
      allow(ENV).to receive(:fetch)
        .with("BASE16_BUILDER_SCHEMES_DIR", described_class::SCHEMES_DIR)
        .and_return("/tmp/base16/builder/schemes")

      expect(described_class.schemes_dir).to eq("/tmp/base16/builder/schemes")
    end
  end

  describe ".templates_dir" do
    before do
      stub_const("#{described_class}::TEMPLATES_DIR", File.join(support_dir, "templates"))
    end

    it "returns the path to the templates directory" do
      expect(described_class.templates_dir).to eq(described_class::TEMPLATES_DIR)
    end

    it "checks the 'BASE16_BUILDER_TEMPLATES_DIR' environment variable" do
      allow(ENV).to receive(:fetch)
        .with("BASE16_BUILDER_TEMPLATES_DIR", described_class::TEMPLATES_DIR)
        .and_return("/tmp/base16/builder/templates")

      expect(described_class.templates_dir).to eq("/tmp/base16/builder/templates")
    end
  end
end
