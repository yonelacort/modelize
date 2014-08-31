describe Modelize do
  describe "hash" do
    let(:data) do
      {
        "root" => {
          "key1" => "value1",
          "key2" => "value2",
          "key_array" => [1, 2, 3],
          "key_object" => {
            "sub_key1" => 123
          }
        }
      }
    end
    let(:instance) { described_class.create(data, format: :hash) }

    it "reprensents the root as variable" do
      expect(instance.root).to_not be_nil
    end

    it "nested values are created as attributes by the key name" do
      expect(instance.root.key1).to eq("value1")
      expect(instance.root.key2).to eq("value2")
    end

    it "nested elements whose value is an array" do
      expect(instance.root.key_array).to be_kind_of(Array)
      expect(instance.root.key_array.first).to eq(1)
    end

    it "whatever nested values are created as attributes by the parent key name" do
      expect(instance.root.key_object.sub_key1).to eq(123)
    end
  end

  describe "json" do
    let(:data) do
      "{
        \"root\" : {
          \"key1\" : \"value1\",
          \"key2\" : \"value2\",
          \"key_array\" : [1, 2, 3],
          \"key_object\" : {
            \"sub_key1\" : 123
          }
        }
      }"
    end
    let(:instance) { described_class.create(data, format: :json) }

    it "reprensents the root as variable" do
      expect(instance.root).to_not be_nil
    end

    it "nested values are created as attributes by the key name" do
      expect(instance.root.key1).to eq("value1")
      expect(instance.root.key2).to eq("value2")
    end

    it "nested elements whose value is an array" do
      expect(instance.root.key_array).to be_kind_of(Array)
      expect(instance.root.key_array.first).to eq(1)
    end

    it "whatever nested values are created as attributes by the parent key name" do
      expect(instance.root.key_object.sub_key1).to eq(123)
    end
  end

  describe "json file" do
    let(:instance) { described_class.create("spec/fixtures/test.json", format: :json, file: true) }

    it "reprensents the root as variable" do
      expect(instance.root).to_not be_nil
    end

    it "nested values are created as attributes by the key name" do
      expect(instance.root.key1).to eq("value1")
      expect(instance.root.key2).to eq("value2")
    end

    it "nested elements whose value is an array" do
      expect(instance.root.key_array).to be_kind_of(Array)
      expect(instance.root.key_array.first).to eq(1)
    end

    it "whatever nested values are created as attributes by the parent key name" do
      expect(instance.root.key_object.sub_key1).to eq(123)
    end

    context "when is malformed" do
      let(:instance) { described_class.create("spec/fixtures/malformed.json", format: :json, file: true) }

      it "raises MalformedFileError" do
        expect{ instance }.to raise_error(Modelize::MalformedFileError)
      end
    end
  end

  describe "xml file" do
    let(:instance) { described_class.create("spec/fixtures/test.xml", format: :xml, file: true) }

    it "reprensents the root as variable" do
      expect(instance.root).to_not be_nil
    end

    it "nested values are created as attributes by the key name" do
      expect(instance.root.key1).to eq("value1")
      expect(instance.root.key2).to eq("value2")
    end

    it "nested elements whose value is an array" do
      expect(instance.root.key_array).to be_kind_of(Array)
      expect(instance.root.key_array.first).to eq("1")
    end

    it "whatever nested values are created as attributes by the parent key name" do
      expect(instance.root.key_object.sub_key1).to eq("123")
    end

    context "when is malformed" do
      let(:instance) { described_class.create("spec/fixtures/malformed.xml", format: :xml, file: true) }
      pending
      # it "raises MalformedFileError" do
      #   expect{ instance }.to raise_error(Modelize::MalformedFileError)
      # end
    end
  end

  describe "csv file" do
    let(:instance) { described_class.create("spec/fixtures/test.csv", format: :csv, file: true) }

    it "returns an array" do
      expect(instance).to be_kind_of(Array)
      expect(instance.count).to eq(2)
    end

    it "attributes for the first element are properly set" do
      expect(instance.first.id).to eq("1")
      expect(instance.first.name).to eq("tom")
    end

    it "attributes for the first element are properly set" do
      expect(instance.last.height).to eq("1.98")
      expect(instance.last.name).to eq("paul")
    end

    context "when is malformed" do
      let(:instance) { described_class.create("spec/fixtures/malformed.csv", format: :csv, file: true) }
      pending
      # it "raises MalformedFileError" do
      #   expect{ instance }.to raise_error(Modelize::MalformedFileError)
      # end
    end
  end

  describe "custom root class" do
    let(:data) do
      {
        "root" => {
          "key1" => "value1",
          "key2" => "value2",
          "key_array" => ["1st", 2, 3],
          "key_object" => {
            "sub_key" => 123
          }
        }
      }
    end

    class Root
      def first_key_array
        root.key_array.first
      end

      def sub_key
        root.key_object.sub_key
      end
    end

    let(:instance) { described_class.create(data, format: :hash, class: Root) }


    it "execute methods defined" do
      expect(instance.sub_key).to eq(123)
      expect(instance.first_key_array).to eq("1st")
    end
  end
end