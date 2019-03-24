RSpec.describe Base16::Builder::Scheme do
  before do
    stub_const("Base16::Builder::SCHEMES_DIR", File.join(support_dir, "schemes"))
  end

  describe ".find" do
    context "when the template is not found:" do
      it "raises an error" do
        expect { described_class.find("missing") }
          .to raise_error(Base16::Builder::Error, "Scheme not found: missing")
      end
    end

    context "when the template is found:" do
      it "returns a Scheme" do
        expect(described_class.find("default-dark"))
          .to be_an_instance_of(described_class)
      end
    end
  end

  describe "#initialize" do
    it "parses the scheme file", aggregate_failures: true do
      scheme_file = File.join(Base16::Builder::SCHEMES_DIR, "default-dark.yaml")
      scheme = described_class.new(file: scheme_file)

      expect(scheme.name).to eq("Default Dark")
      expect(scheme.author).to eq("Chris Kempson (http://chriskempson.com)")
      expect(scheme.bases).to eq({
        "base00" => "181818",
        "base01" => "282828",
        "base02" => "383838",
        "base03" => "585858",
        "base04" => "b8b8b8",
        "base05" => "d8d8d8",
        "base06" => "e8e8e8",
        "base07" => "f8f8f8",
        "base08" => "ab4642",
        "base09" => "dc9656",
        "base0A" => "f7ca88",
        "base0B" => "a1b56c",
        "base0C" => "86c1b9",
        "base0D" => "7cafc2",
        "base0E" => "ba8baf",
        "base0F" => "a16946",
      })
    end

    context "when the scheme file is missing attributes" do
      it "raises an error" do
        scheme_file = File.join(Base16::Builder::SCHEMES_DIR, "invalid.yaml")

        expect { described_class.new(file: scheme_file) }
          .to raise_error(KeyError)
      end
    end
  end

  describe "#slug" do
    let(:scheme) do
      scheme_file = File.join(Base16::Builder::SCHEMES_DIR, "default-dark.yaml")
      described_class.new(file: scheme_file)
    end

    it "turns the name into a slug" do
      expect(scheme.slug).to eq("default-dark")
    end

    it "accepts an optional separator" do
      expect(scheme.slug(separator: "_")).to eq("default_dark")
    end
  end
end
