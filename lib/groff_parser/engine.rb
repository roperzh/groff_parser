require "groff_parser/document"

module GroffParser

  # A handy class who offers some methods to handle multiple documents at the
  # same time

  class Engine

    # @since 0.1.0
    attr_accessor :path

    # Stores a path, this one can be a path to a directory or to an specific
    # file, use the proper class methods is up to you
    #
    # @since 0.1.0
    #
    # @example
    #   GroffParser::Engine.new("path/to/file")
    #   GroffParser::Engine.new("path/to/directory")
    #
    # @param path [String] the path to be stored
    #
    # @return [GroffParser::Engine] a new Engine instance

    def initialize(path: Dir.pwd)
      @path = path
    end

    # Parse a document located on a given path, if the document is contained
    # inside of the `@path` variable you can pass only the document name
    # otherwise it searchs for path provided as a full path
    #
    # @since 0.1.0
    #
    # @example
    #   parser = GroffParser::Engine.new("some/path")
    #   parser.parse("path/to/another_file")
    #   # Will parse another_file properly
    #   parser.parse("some_file")
    #   # Will search for a file called some_file in some/path
    #
    # @param document_path [String] path for a document to parse
    #
    # @param zipped [Boolean] indicates if the file is zipped or not (gzip)
    #
    # @return [GroffParser::Document] the document, parsed and ready to be manipulated

    def parse(document_path, zipped: zipped)
      dpath = document_path.include?(path) ? document_path : "#{path}/#{document_path}"

      Document.new(dpath, zipped: zipped)
    end

    # Parse all documents in a given directory, with a given format
    #
    # @since 0.1.0
    #
    # @param format [Symbol, String] indicates the output format, could be:
    #   dvi, html, lbp, lj4, ps, ascii, cp1047, latin1, utf8, X75, X75, X100, X100
    #   (default = utf8)
    #
    # @param zipped [Boolean] indicates if the file is zipped or not (gzip)
    #
    # @return [Array<GroffParser::Document>] an array of all the parsed documents

    def parse_all(format: :utf8, zipped: false)
      documents   = []
      search_path = zipped ? "#{path}/*.gz" : "#{path}/*[0-9]"

      Dir.glob(search_path) do |document|
        documents << parse(document, zipped: zipped)
      end

      documents
    end

    # Executes a passed block, giving a GroffParser::Document as argument
    #
    # @since 0.1.0
    #
    # @example
    #  parser = GroffParser::Engine.new("/path/to/file")
    #  parser.apply { |document| document.parse }

    def apply_to(*args)
      yield parse(args.join(" "))
    end

    # Executes a passed block over all the documents in the current directory,
    # giving a GroffParser::Document as argument for each block execution
    #
    # @since 0.1.0
    #
    # @example
    #   parser = GroffParser::Engine.new("/folder/with/some/files")
    #   parser.apply_all { |document|  document.parse }
    #
    # @param zipped [Boolean] indicates if the file is zipped or not (gzip)
    #
    # @return [nil]

    def apply_to_all(zipped: false)
      search_path = zipped ? "#{path}/*.gz" : "#{path}/*"

      Dir.glob(search_path) do |document|
        yield parse(document, zipped)
      end
    end
  end
end
