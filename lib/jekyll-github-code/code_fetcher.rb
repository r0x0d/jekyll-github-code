# frozen_string_literal: true

require 'net/http'
require 'uri'

module Jekyll
  module GitHubCode
    # Fetches code content from GitHub
    class CodeFetcher
      class FetchError < StandardError; end

      def self.fetch(url)
        uri = URI.parse(url)
        response = Net::HTTP.get_response(uri)

        case response
        when Net::HTTPSuccess
          response.body
        when Net::HTTPRedirection
          fetch(response['location'])
        else
          raise FetchError, "Failed to fetch #{url}: #{response.code} #{response.message}"
        end
      rescue StandardError => e
        raise FetchError, "Error fetching #{url}: #{e.message}"
      end
    end
  end
end

