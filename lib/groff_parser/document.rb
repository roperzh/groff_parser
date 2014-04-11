module GroffParser

  # A class representing a specific document to be parsed

  class Document

    attr_accessor :path

    # Initializes the document class
    #
    # @since 0.1.0
    #
    # @example
    #   zipped_document = GroffParser::Document.new("path/to/file.gz", zipped: true)
    #   unzipped_document = GroffParser::Document.new("path/to/file.1",  zipped: false)
    #
    # @param path [String] the path where the document is located
    #
    # @param zipped [Boolean] indicates if the document is zipped or not
    #
    # @return [GroffParser::Document] a new instance of a Document class

    def initialize(path, zipped: false)
      @path   = path
      @zipped = zipped
    end

    # Currently in beta, given a section name it tries to search within the
    # current document for a title passed as a parameter and return the contents
    # within the title and the next one
    #
    # @since 0.1.0
    #
    # @example
    #   document.section("MY SECTION")
    #   # searches for a section like this one:
    #   # .SH
    #   #  MY SECTION
    #   #  ...
    #
    # @param name [String, Symbol] name of the section
    #
    # @return [String, nil] the contents of the section or nil if the section
    #   doesn't exist yet

    def section(name)
      raw_content[/SH \"#{name}\"(.*?)SH/im].gsub("SH", "")
    end

    # Raw content of the document, without being parsed, in pure
    # groff format
    #
    # @since 0.1.0
    #
    # @example
    #   document.raw_content
    #
    # @return [String] the document content in groff format

    def raw_content
      @raw_content ||= `#{get} #{@path}`
    end

    # Content of the document in a especific format
    #
    # @since 0.1.0
    #
    # @example
    #   document.formatted_content(:html)
    #
    # @param format [Symbol, String] indicates the output format, could be:
    #   dvi, html, lbp, lj4, ps, ascii, cp1047, latin1, utf8, X75, X75, X100, X100
    #
    # @return [String] the document content formated in the requested format

    def formatted_content(format)
      `#{get} #{@path} | groff -mandoc -T#{format}`
    end

    private

    # Little helper to know which command should be executed in order to parse
    # files properly
    #
    # @since 0.1.0
    #
    # @example
    #   @zipped = true
    #   get # => "zcat"
    #
    #   @zipped = false
    #   get # => "cat"
    #
    # @return [String] the proper parameter

    def get
      @zipped ? "zcat" : "cat"
    end
  end
end
