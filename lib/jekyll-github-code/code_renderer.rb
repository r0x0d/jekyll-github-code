# frozen_string_literal: true

require 'cgi'

module Jekyll
  module GitHubCode
    # Renders the code block with syntax highlighting
    class CodeRenderer
      LANGUAGE_MAP = {
        'rb' => 'ruby',
        'py' => 'python',
        'js' => 'javascript',
        'ts' => 'typescript',
        'yml' => 'yaml',
        'md' => 'markdown',
        'sh' => 'bash',
        'dockerfile' => 'dockerfile',
        'containerfile' => 'dockerfile'
      }.freeze

      def initialize(reference, code, options = {})
        @reference = reference
        @code = code
        @options = options
      end

      def render
        processed_code = process_line_range(@code)
        escaped_code = CGI.escapeHTML(processed_code)
        language = detect_language

        <<~HTML
          <div class="github-code-block">
            <div class="github-code-header">
              <span class="github-code-filename">
                <svg class="github-icon" viewBox="0 0 16 16" width="16" height="16">
                  <path fill="currentColor" d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"/>
                </svg>
                <a href="#{@reference.github_url}" target="_blank" rel="noopener noreferrer">#{@reference.filename}#{line_range_label}</a>
              </span>
              <button class="github-code-copy" onclick="copyGitHubCode(this)" title="Copy code">
                <svg viewBox="0 0 16 16" width="16" height="16">
                  <path fill="currentColor" d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 010 1.5h-1.5a.25.25 0 00-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 00.25-.25v-1.5a.75.75 0 011.5 0v1.5A1.75 1.75 0 019.25 16h-7.5A1.75 1.75 0 010 14.25v-7.5z"/>
                  <path fill="currentColor" d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0114.25 11h-7.5A1.75 1.75 0 015 9.25v-7.5zm1.75-.25a.25.25 0 00-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 00.25-.25v-7.5a.25.25 0 00-.25-.25h-7.5z"/>
                </svg>
              </button>
            </div>
            <div class="github-code-content">
              <pre><code class="language-#{language}">#{escaped_code}</code></pre>
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

      def detect_language
        ext = @reference.extension.downcase
        LANGUAGE_MAP[ext] || ext
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

