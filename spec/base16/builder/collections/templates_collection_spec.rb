RSpec.describe Base16::Builder::TemplatesCollection do
  before do
    stub_const("Base16::Builder::SCHEMES_DIR", File.join(support_dir, "schemes"))
    stub_const("Base16::Builder::TEMPLATES_DIR", File.join(support_dir, "templates"))
  end

  describe "#initialize" do
    it "builds a collection of 'Base16::Builder::Template' objects" do
      template_file = File.join(Base16::Builder::TEMPLATES_DIR, "alacritty.yml.erb")
      collection = described_class.new([template_file])

      expect(collection.first).to be_an_instance_of(Base16::Builder::Template)
    end
  end

  describe "#render" do
    pending
  end
end
