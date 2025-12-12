# frozen_string_literal: true

require 'jekyll'

require_relative 'jekyll-github-code/version'
require_relative 'jekyll-github-code/github_reference'
require_relative 'jekyll-github-code/code_fetcher'
require_relative 'jekyll-github-code/code_renderer'
require_relative 'jekyll-github-code/tag'
require_relative 'jekyll-github-code/generator'

module Jekyll
  module GitHubCode
  end
end

