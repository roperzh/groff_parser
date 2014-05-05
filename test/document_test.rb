# encoding: utf-8

require File.expand_path(File.join("test/test_helper"))

describe GroffParser::Document do

  let(:zipped_document)   {
    GroffParser::Document.new("test/fixtures/git.1.gz", :zipped)
  }

  let(:unzipped_document) {
    GroffParser::Document.new("test/fixtures/git.1")
  }

  let(:timestamp) { Regexp.new(/\<\!\-\- CreationDate\: (.*?) \-\-\>/) }

  describe "#raw_section" do
    it "returns the contents of a section delimited by a given title" do
      zipped_document.raw_section("NAME").must_equal(
        " \"\"\ngit \\- the stupid content tracker\n."
      )

      unzipped_document.raw_section("NAME").must_equal(
        " \"\"\ngit \\- the stupid content tracker\n."
      )
    end

    it "returns the same results whether the document is zipped or not" do
      zipped_document.raw_section("NAME").must_equal(
        unzipped_document.raw_section("NAME")
      )
    end

    it "returns nil if the provided section does not exists" do
      zipped_document.raw_section("UNEXISTENT_SECTION").must_equal(nil)
    end
  end

  describe "#formatted_section" do
    context("given a format") do

      let(:format) { :utf8 }

      it "returns the same results whether the document is zipped or not" do
        zipped_document.formatted_section("NAME", format).must_equal(
          unzipped_document.formatted_section("NAME", format)
        )
      end

      it "returns nil if the provided section does not exists" do
        zipped_document.formatted_section("UNEXISTENT_SECTION", format).must_equal(nil)
      end
    end
  end

  describe "#raw_content" do
    it "returns the content in groff format" do
      zipped_raw_content   = `zcat test/fixtures/git.1.gz`
      unzipped_raw_content = `cat test/fixtures/git.1`

      zipped_document.raw_content.must_equal zipped_raw_content
      unzipped_document.raw_content.must_equal unzipped_raw_content
    end

    it "returns the same results whether the document is zipped or not" do
      zipped_document.raw_content.must_equal(
        unzipped_document.raw_content
      )
    end
  end

  describe "#formatted_content" do

    it "returns the content in the requested format" do
      # Due to a small delay parsing data, we need to supress the timestamps
      method_content_from_zip = zipped_document.formatted_content(:html)
        .gsub(timestamp, "")

      method_content_from_unzip = unzipped_document.formatted_content(:html)
        .gsub(timestamp, "")

      method_content_from_zip.must_equal(
        `zcat test/fixtures/git.1.gz | groff -mandoc -Thtml`.gsub(timestamp, "")
      )

      method_content_from_unzip.must_equal(
        `cat test/fixtures/git.1 | groff -mandoc -Thtml`.gsub(timestamp, "")
      )
    end

    it "returns the same results whether the document is zipped or not" do
      zipped_document.formatted_content(:html).gsub(timestamp, "").must_include(
        unzipped_document.formatted_content(:html).gsub(timestamp, "")
      )
    end
  end

  describe "#groff" do
    context "given a set of flags" do
      it "executes the groff command with the flags provided" do
        zipped_document.groff(:T => :utf8, :m => :mandoc).must_equal(
          `zcat test/fixtures/git.1.gz | groff -Tutf8 -mmandoc`
        )

        zipped_document.groff(:T => :utf8, :m => :mandoc).must_equal(
          `cat test/fixtures/git.1 | groff -Tutf8 -mmandoc`
        )
      end
    end

    context "without flags" do
      it "executes groff command without any aditional options" do
        zipped_document.groff.gsub(timestamp, "").must_equal(
          `zcat test/fixtures/git.1.gz | groff`.gsub(timestamp, "")
        )

        zipped_document.groff.gsub(timestamp, "").must_equal(
          `cat test/fixtures/git.1 | groff`.gsub(timestamp, "")
        )
      end
    end
  end
end
