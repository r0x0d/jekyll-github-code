# frozen_string_literal: true

require 'liquid'
require 'cgi'

module Jekyll
  module GitHubCode
    # The main Liquid tag for embedding GitHub code
    class Tag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super
        @markup = markup.strip
      end

      def render(context)
        # Resolve any Liquid variables in the markup
        resolved_markup = context[@markup] || @markup

        reference = GitHubReference.new(resolved_markup)
        code = CodeFetcher.fetch(reference.raw_url)
        renderer = CodeRenderer.new(reference, code)
        renderer.render
      rescue ArgumentError => e
        error_html("Invalid GitHub reference: #{e.message}")
      rescue CodeFetcher::FetchError => e
        error_html("Failed to fetch code: #{e.message}")
      rescue StandardError => e
        error_html("Error: #{e.message}")
      end

      private

      def error_html(message)
        <<~HTML
          <div class="github-code-error">
            <strong>GitHub Code Error:</strong> #{CGI.escapeHTML(message)}
          </div>
        HTML
      end
    end
  end
end

Liquid::Template.register_tag('github_code', Jekyll::GitHubCode::Tag)

