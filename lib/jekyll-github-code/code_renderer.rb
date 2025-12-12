# frozen_string_literal: true

require 'cgi'
require 'rouge'

module Jekyll
  module GitHubCode
    # Renders the code block with syntax highlighting using Rouge
    class CodeRenderer
      def initialize(reference, code, options = {})
        @reference = reference
        @code = code
        @options = options
      end

      def render
        processed_code = process_line_range(@code)
        highlighted_code = highlight_code(processed_code)

        <<~HTML
          <div class="github-code-block">
            <div class="github-code-header">
              <span class="github-code-filename">
                <svg class="github-icon" viewBox="0 0 16 16" width="16" height="16">
                  <path fill="currentColor" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"/>
                </svg>
                <a href="#{@reference.github_url}" target="_blank" rel="noopener noreferrer">#{@reference.filename}#{line_range_label}</a>
              </span>
            </div>
            <div class="github-code-content highlight">
              <pre><code>#{highlighted_code}</code></pre>
            </div>
          </div>
        HTML
      end

      private

      def process_line_range(code)
        return code unless @reference.line_range?

        lines = code.lines
        start_idx = @reference.start_line - 1
        end_idx = (@reference.end_line || @reference.start_line) - 1

        # Clamp to valid range
        start_idx = [0, start_idx].max
        end_idx = [lines.length - 1, end_idx].min

        lines[start_idx..end_idx].join
      end

      def highlight_code(code)
        lexer = find_lexer
        formatter = Rouge::Formatters::HTML.new
        formatter.format(lexer.lex(code))
      rescue StandardError
        # Fallback to plain text if highlighting fails
        CGI.escapeHTML(code)
      end

      def find_lexer
        filename = @reference.filename

        # Try to find lexer by filename (Rouge is smart about this)
        lexer = Rouge::Lexer.find_fancy(filename)
        return lexer if lexer

        # Try by extension
        ext = @reference.extension.downcase
        lexer = Rouge::Lexer.find_fancy(ext)
        return lexer if lexer

        # Try guessing from the source content
        lexer = Rouge::Lexer.guess(filename: filename, source: @code)
        return lexer if lexer

        # Fallback to plain text
        Rouge::Lexers::PlainText.new
      end

      def line_range_label
        return '' unless @reference.line_range?

        if @reference.end_line
          " (L#{@reference.start_line}-L#{@reference.end_line})"
        else
          " (L#{@reference.start_line})"
        end
      end
    end
  end
end
