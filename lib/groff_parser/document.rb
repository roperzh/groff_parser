module GroffParser

  # A class representing a specific document to be parsed

  class Document

    attr_accessor :path

    # Initializes the document class
    #
    # @since 0.1.0
    #
    # @example
    #   zipped_document = GroffParser::Document.new("path/to/file.gz", :zipped)
    #   unzipped_document = GroffParser::Document.new("path/to/file.1")
    #
    # @param path [String] the path where the document is located
    #
    # @param zipped [Symbol, Boolean, String] indicates if the document is zipped or not
    #
    # @return [GroffParser::Document] a new instance of a Document class

    def initialize(path, zipped = nil)
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
      raw_section = raw_content[/SH (?:\")?#{name}(?:\")?(.*?)SH/im]

      return raw_section.gsub("SH", "").gsub("#{name}", "") if raw_section
    end

    # Executes the groff command, with a given set of flags, and returns the
    # output
    #
    # @since 0.4.0
    #
    # @example
    #   document.groff(m: :mandoc)
    #   # will execute: `groff -m mandoc
    #
    # @param flags [Hash] hash containing flags in key-value format
    #
    # @return [String] the result of the command


    def groff(flags = {})
      `#{get} #{@path} | groff #{formatted_flags(flags)}`
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

    # Helper to reduce a hash containing flags to a single line string
    # according to the usual GNU convention
    #
    # @since 0.4.0
    #
    # @example
    #   formatted_flags(m: :mandoc) # => "-mmandoc"
    #
    # @params flags [Hash] flags to be reduced
    #
    # @return [String] string with the parsed flags following the usual GNU convention

    def formatted_flags(flags)
      flags.reduce("") {
        |result, flag| result.concat(" -#{flag[0]}#{flag[1]}")
      }
    end
  end
end
