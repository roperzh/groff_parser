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
      engine.parse_all.must_equal(
        [GroffParser::Document.new("test/fixtures/git.1")]
      )
    end
  end
end
