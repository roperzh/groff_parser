require File.expand_path(File.join("test/test_helper"))

describe GroffParser::Engine do

  let(:engine) { GroffParser::Engine.new("test/fixtures") }

  describe "#parse" do
    context "given a zipped document" do
      it "returns a new GroffParser::Document instance" do
        engine.parse("git.1.gz", :zipped).class.must_equal(
          GroffParser::Document
        )
      end

      it "allows to retrieve information of the parsed file" do
        engine.parse("git.1.gz", :zipped).raw_content.must_equal(
          GroffParser::Document.new("test/fixtures/git.1.gz", :zipped)
            .raw_content
        )
      end
    end

    context "given an unzipped document" do
      it "returns a new GroffParser::Document instance" do
        engine.parse("git.1").class.must_equal(
          GroffParser::Document
        )
      end

      it "allows to retrieve information of the parsed file" do
        engine.parse("git.1").raw_content.must_equal(
          GroffParser::Document.new("test/fixtures/git.1.gz", :zipped)
            .raw_content
        )
      end
    end

  end

  describe "#parse_all" do
    it "returns an array with all the documents contents present in the path" do
      documents = engine.parse_all

      documents.length.must_equal(1)
      documents.first.class.must_equal(GroffParser::Document)
      documents.first.path.must_equal("test/fixtures/git.1")
    end
  end
end
