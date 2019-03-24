require "fakefs/spec_helpers"

RSpec.describe Base16::Builder::Template do
  before do
    stub_const("Base16::Builder::SCHEMES_DIR", File.join(support_dir, "schemes"))
    stub_const("Base16::Builder::TEMPLATES_DIR", File.join(support_dir, "templates"))
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
      expect { template.render(scheme: scheme) }
        .to change { File.directory?("out/alacritty") }.from(false).to(true)
    end

    it "creates the rendered template file", aggregate_failures: true do
      expect { template.render(scheme: scheme) }
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

      expect { template.render(scheme: scheme) }
        .to change { File.directory?("/tmp/base16/builder/out/alacritty") }.from(false).to(true)
        .and change { File.file?("/tmp/base16/builder/out/alacritty/base16-default-dark.yml") }.from(false).to(true)

      expect(File.read("/tmp/base16/builder/out/alacritty/base16-default-dark.yml"))
        .to eq(File.read(File.join(support_dir, "out/alacritty/base16-default-dark.yml")))
    end
  end
end
