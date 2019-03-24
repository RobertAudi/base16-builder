RSpec.describe Base16::Builder::Scheme do
  before do
    stub_const("Base16::Builder::SCHEMES_DIR", File.join(support_dir, "schemes"))
  end

  describe ".all" do
    it "returns an instance of 'Base16::Builder::SchemesCollection'" do
      pending "The 'invalid' scheme makes this test fail"

      expect(described_class.all).to be_an_instance_of(Base16::Builder::SchemesCollection)
    end

    it "retrieves all available schemes", aggregate_failures: true do
      pending "The 'invalid' scheme makes this test fail"

      schemes = described_class.all

      expect(schemes.count).to eq(2)
      expect(schemes)
        .to include("Default Dark")
        .and include("Railscasts")
    end
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

  describe "#to_s" do
    it "returns the name and author of the scheme" do
      scheme_file = File.join(Base16::Builder::SCHEMES_DIR, "default-dark.yaml")
      scheme = described_class.new(file: scheme_file)

      expect(scheme.to_s).to eq("Default Dark by Chris Kempson (http://chriskempson.com)")
    end

    describe "#inspect" do
      it "returns a human-readable representation of the template object" do
        scheme_file = File.join(Base16::Builder::SCHEMES_DIR, "default-dark.yaml")
        scheme = described_class.new(file: scheme_file)

        name = "Default Dark"
        author = "Chris Kempson (http://chriskempson.com)"
        bases = %q[{"base00"=>"#181818", "base01"=>"#282828", "base02"=>"#383838", "base03"=>"#585858", "base04"=>"#b8b8b8", "base05"=>"#d8d8d8", "base06"=>"#e8e8e8", "base07"=>"#f8f8f8", "base08"=>"#ab4642", "base09"=>"#dc9656", "base0A"=>"#f7ca88", "base0B"=>"#a1b56c", "base0C"=>"#86c1b9", "base0D"=>"#7cafc2", "base0E"=>"#ba8baf", "base0F"=>"#a16946"}]

        expect(scheme.inspect).to eq(%Q[#<#{described_class.name} name:"#{name}" author:"#{author}" bases:#{bases}>])
      end
    end

    describe "#==" do
      let(:scheme) do
        scheme_file = File.join(Base16::Builder::SCHEMES_DIR, "railscasts.yaml")
        described_class.new(file: scheme_file)
      end

      context "when compared to a #{described_class}" do
        it "checks the 'name', 'author' and 'bases' attributes of each object" do
          scheme_file = File.join(Base16::Builder::SCHEMES_DIR, "railscasts.yaml")

          expect(scheme).to eq(described_class.new(file: scheme_file))
        end
      end

      context "when compared to a String" do
        it "compares its String representation to the other String" do
          expect(scheme).to eq("Railscasts by Ryan Bates (http://railscasts.com)")
        end

        it "compares its 'name' attribute to the other String as a fallback" do
          expect(scheme).to eq("Railscasts")
        end
      end

      context "when compared with an arbitrary object" do
        it "compares itself to the String representation of the other object" do
          expect(scheme).to eq(:Railscasts)
        end
      end
    end
  end
end
