require "fakefs/spec_helpers"

RSpec.describe Base16::Builder::Template do
  before do
    stub_const("Base16::Builder::SCHEMES_DIR", File.join(support_dir, "schemes"))
    stub_const("Base16::Builder::TEMPLATES_DIR", File.join(support_dir, "templates"))
  end

  describe ".all" do
    it "returns an instance of 'Base16::Builder::TemplatesCollection'" do
      expect(described_class.all).to be_an_instance_of(Base16::Builder::TemplatesCollection)
    end

    it "retrieves all available templates", aggregate_failures: true do
      templates = described_class.all

      expect(templates.count).to eq(2)
      expect(templates)
        .to include("alacritty")
        .and include("fzf")
    end
  end

  describe ".count" do
    it "returns the number of available templates" do
      expect(described_class.count).to eq(2)
    end
  end

  describe ".find_each" do
    context "without a block" do
      it "returns a collection" do
        expect(described_class.find_each)
          .to be_an_instance_of(Base16::Builder::TemplatesCollection)
      end
    end

    context "with a block" do
      it "yields the block with every template" do
        templates = %w[alacritty.yml.erb fzf.sh.erb].map do |t|
          described_class.new(file: File.join(Base16::Builder::TEMPLATES_DIR, t))
        end

        expect { |b| described_class.find_each(&b) }
          .to yield_successive_args(*templates)
      end
    end
  end

  describe ".find" do
    context "when the template is not found:" do
      it "raises an error" do
        expect { described_class.find("missing") }
          .to raise_error(Base16::Builder::Error, "No templates mathing name: missing")
      end
    end

    context "when the template is found:" do
      it "returns a Template" do
        expect(described_class.find("alacritty"))
          .to be_an_instance_of(described_class)
      end
    end
  end

  describe "#initialize" do
    it "prepares the template for rendering" do
      template_file = File.join(Base16::Builder::TEMPLATES_DIR, "alacritty.yml.erb")
      template = described_class.new(file: template_file)

      expect(template.name).to eq("alacritty")
    end
  end

  describe "#render" do
    around(:example) do |example|
      FakeFS.with_fresh do
        FakeFS::FileSystem.clone(support_dir)
        example.run
      end
    end

    let(:scheme) { Base16::Builder::Scheme.find("default-dark") }
    let(:template) { described_class.find("alacritty") }

    it "creates the output directory" do
      expect { template.render(schemes: scheme) }
        .to change { File.directory?("out/alacritty") }.from(false).to(true)
    end

    it "creates the rendered template file", aggregate_failures: true do
      expect { template.render(schemes: scheme) }
        .to change { File.file?("out/alacritty/base16-default-dark.yml") }.from(false).to(true)

      expect(File.read("out/alacritty/base16-default-dark.yml"))
        .to eq(File.read(File.join(support_dir, "out/alacritty/base16-default-dark.yml")))
    end

    it "checks the 'BASE16_BUILDER_OUTPUT_DIR' environment variable", aggregate_failures: true do
      allow(ENV).to receive(:fetch)
        .with("BASE16_BUILDER_SCHEMES_DIR", Base16::Builder::SCHEMES_DIR)
        .and_call_original

      allow(ENV).to receive(:fetch)
        .with("BASE16_BUILDER_TEMPLATES_DIR", Base16::Builder::TEMPLATES_DIR)
        .and_call_original

      allow(ENV).to receive(:fetch)
        .with("BASE16_BUILDER_OUTPUT_DIR", File.join(Dir.pwd, "out"))
        .and_return("/tmp/base16/builder/out")

      expect { template.render(schemes: scheme) }
        .to change { File.directory?("/tmp/base16/builder/out/alacritty") }.from(false).to(true)
        .and change { File.file?("/tmp/base16/builder/out/alacritty/base16-default-dark.yml") }.from(false).to(true)

      expect(File.read("/tmp/base16/builder/out/alacritty/base16-default-dark.yml"))
        .to eq(File.read(File.join(support_dir, "out/alacritty/base16-default-dark.yml")))
    end
  end

  describe "#to_s" do
    it "returns the name of the template" do
      template_file = File.join(Base16::Builder::TEMPLATES_DIR, "alacritty.yml.erb")
      template = described_class.new(file: template_file)

      expect(template.to_s).to eq("alacritty")
    end
  end

  describe "#inspect" do
    it "returns a human-readable representation of the template object" do
      template_file = File.join(Base16::Builder::TEMPLATES_DIR, "alacritty.yml.erb")
      template = described_class.new(file: template_file)

      expect(template.inspect).to eq(%Q[#<#{described_class.name} name:"alacritty">])
    end
  end

  describe "#==" do
    let(:template) do
      template_file = File.join(Base16::Builder::TEMPLATES_DIR, "alacritty.yml.erb")
      described_class.new(file: template_file)
    end

    context "when compared to a #{described_class}" do
      it "checks the 'name' attribute of each object" do
        template_file = File.join(Base16::Builder::TEMPLATES_DIR, "alacritty.yml.erb")
        expect(template).to eq(described_class.new(file: template_file))
      end
    end

    context "when compared to a String" do
      it "compares its 'name' attribute to the String" do
        expect(template).to eq("alacritty")
      end
    end

    context "when compared with an arbitrary object" do
      it "compares itself to the String representation of the other object" do
        expect(template).to eq(:alacritty)
      end
    end
  end
end
