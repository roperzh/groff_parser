require File.expand_path(File.join("test/test_helper"))

describe GroffParser::Engine do

  let(:engine) { GroffParser::Engine.new(path: "test/fixtures") }

  describe "#parse" do
    it "returns the contents of a document, formatted by the requested format" do
      engine.parse("git.1.gz", true, format: :utf8).must_equal(
        `cat test/fixtures/git.1 | groff -mandoc -Tutf8`
      )
    end
  end

  describe "#parse_all" do
    it "returns an array with all the documents contents present in the path" do
      engine.parse_all.must_equal(
        [`cat test/fixtures/git.1 | groff -mandoc -Tutf8`]
      )
    end
  end
end
