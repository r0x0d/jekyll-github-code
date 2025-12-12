# frozen_string_literal: true

module Jekyll
  module GitHubCode
    # Represents a parsed GitHub URL with repository, path, and optional line range
    class GitHubReference
      attr_reader :owner, :repo, :branch, :path, :start_line, :end_line

      GITHUB_URL_PATTERN = %r{
        ^
        (?:https?://github\.com/)?  # Optional full URL prefix
        ([^/]+)/                     # Owner
        ([^/]+)/                     # Repo
        blob/
        ([^/]+)/                     # Branch
        (.+?)                        # File path
        (?:\#L(\d+)(?:-L(\d+))?)?    # Optional line range
        $
      }x.freeze

      def initialize(reference)
        match = reference.strip.match(GITHUB_URL_PATTERN)
        raise ArgumentError, "Invalid GitHub reference: #{reference}" unless match

        @owner = match[1]
        @repo = match[2]
        @branch = match[3]
        @path = match[4]
        @start_line = match[5]&.to_i
        @end_line = match[6]&.to_i
      end

      def raw_url
        "https://raw.githubusercontent.com/#{@owner}/#{@repo}/#{@branch}/#{@path}"
      end

      def github_url
        base = "https://github.com/#{@owner}/#{@repo}/blob/#{@branch}/#{@path}"
        return base unless @start_line

        line_fragment = @end_line ? "L#{@start_line}-L#{@end_line}" : "L#{@start_line}"
        "#{base}##{line_fragment}"
      end

      def filename
        File.basename(@path)
      end

      def extension
        File.extname(@path).delete_prefix('.')
      end

      def line_range?
        !@start_line.nil?
      end
    end
  end
end

