# frozen_string_literal: true

require_relative 'lib/jekyll-github-code/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-github-code'
  spec.version       = Jekyll::GitHubCode::VERSION
  spec.authors       = ['Rodolfo Olivieri']
  spec.email         = ['rodolfo.olivieri3@gmail.com']

  spec.summary       = 'A Jekyll plugin to embed code from GitHub repositories'
  spec.description   = 'Embed code snippets from GitHub repositories directly in your Jekyll ' \
                       'blog posts with automatic syntax highlighting, line range support, and ' \
                       'clickable links to the source.'
  spec.homepage      = 'https://github.com/r0x0d/jekyll-github-code'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/r0x0d/jekyll-github-code/issues',
    'changelog_uri' => 'https://github.com/r0x0d/jekyll-github-code/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://github.com/r0x0d/jekyll-github-code#readme',
    'homepage_uri' => spec.homepage,
    'source_code_uri' => 'https://github.com/r0x0d/jekyll-github-code',
    'rubygems_mfa_required' => 'true'
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) ||
        f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  # If git is not available, use a fallback
  if spec.files.empty?
    spec.files = Dir[
      'lib/**/*',
      'assets/**/*',
      'LICENSE',
      'README.md',
      'CHANGELOG.md'
    ]
  end

  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'jekyll', '>= 3.7', '< 5.0'
  spec.add_dependency 'liquid', '>= 4.0'
  spec.add_dependency 'rouge', '>= 3.0'

  # Development dependencies
  spec.add_development_dependency 'minitest', '~> 5.20'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.57'
  spec.add_development_dependency 'webmock', '~> 3.19'
end

