# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'

# Load the gem
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'jekyll-github-code'

class GitHubReferenceTest < Minitest::Test
  def test_parses_simple_reference
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile')

    assert_equal 'r0x0d', ref.owner
    assert_equal 'toolbox-dev', ref.repo
    assert_equal 'main', ref.branch
    assert_equal 'toolbox/environment/fedora-packaging.Containerfile', ref.path
    assert_nil ref.start_line
    assert_nil ref.end_line
  end

  def test_parses_reference_with_single_line
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/README.md#L5')

    assert_equal 'r0x0d', ref.owner
    assert_equal 'toolbox-dev', ref.repo
    assert_equal 'main', ref.branch
    assert_equal 'README.md', ref.path
    assert_equal 5, ref.start_line
    assert_nil ref.end_line
  end

  def test_parses_reference_with_line_range
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile#L5-L15')

    assert_equal 'r0x0d', ref.owner
    assert_equal 'toolbox-dev', ref.repo
    assert_equal 'main', ref.branch
    assert_equal 'toolbox/environment/fedora-packaging.Containerfile', ref.path
    assert_equal 5, ref.start_line
    assert_equal 15, ref.end_line
  end

  def test_parses_full_github_url
    ref = Jekyll::GitHubCode::GitHubReference.new('https://github.com/r0x0d/toolbox-dev/blob/main/README.md')

    assert_equal 'r0x0d', ref.owner
    assert_equal 'toolbox-dev', ref.repo
    assert_equal 'main', ref.branch
    assert_equal 'README.md', ref.path
  end

  def test_parses_full_github_url_with_line_range
    ref = Jekyll::GitHubCode::GitHubReference.new('https://github.com/r0x0d/toolbox-dev/blob/main/src/app.py#L10-L20')

    assert_equal 'r0x0d', ref.owner
    assert_equal 'toolbox-dev', ref.repo
    assert_equal 'main', ref.branch
    assert_equal 'src/app.py', ref.path
    assert_equal 10, ref.start_line
    assert_equal 20, ref.end_line
  end

  def test_generates_correct_raw_url
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/README.md')

    assert_equal 'https://raw.githubusercontent.com/r0x0d/toolbox-dev/main/README.md', ref.raw_url
  end

  def test_generates_correct_github_url_without_lines
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/README.md')

    assert_equal 'https://github.com/r0x0d/toolbox-dev/blob/main/README.md', ref.github_url
  end

  def test_generates_correct_github_url_with_single_line
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/README.md#L5')

    assert_equal 'https://github.com/r0x0d/toolbox-dev/blob/main/README.md#L5', ref.github_url
  end

  def test_generates_correct_github_url_with_line_range
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/README.md#L5-L15')

    assert_equal 'https://github.com/r0x0d/toolbox-dev/blob/main/README.md#L5-L15', ref.github_url
  end

  def test_extracts_filename
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile')

    assert_equal 'fedora-packaging.Containerfile', ref.filename
  end

  def test_extracts_extension
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/src/app.py')

    assert_equal 'py', ref.extension
  end

  def test_extracts_containerfile_extension
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/fedora-packaging.Containerfile')

    assert_equal 'Containerfile', ref.extension
  end

  def test_line_range_detection
    ref_with_lines = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/README.md#L5-L15')
    ref_without_lines = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/README.md')

    assert ref_with_lines.line_range?
    refute ref_without_lines.line_range?
  end

  def test_raises_on_invalid_reference
    assert_raises(ArgumentError) do
      Jekyll::GitHubCode::GitHubReference.new('invalid-reference')
    end
  end

  def test_raises_on_empty_reference
    assert_raises(ArgumentError) do
      Jekyll::GitHubCode::GitHubReference.new('')
    end
  end

  def test_handles_different_branches
    ref = Jekyll::GitHubCode::GitHubReference.new('owner/repo/blob/feature/my-branch/src/file.js')

    assert_equal 'feature', ref.branch
    assert_equal 'my-branch/src/file.js', ref.path
  end
end

class CodeFetcherTest < Minitest::Test
  def setup
    WebMock.enable!
  end

  def teardown
    WebMock.disable!
  end

  def test_fetches_code_successfully
    stub_request(:get, 'https://raw.githubusercontent.com/owner/repo/main/file.rb')
      .to_return(body: "def hello\n  puts 'world'\nend", status: 200)

    code = Jekyll::GitHubCode::CodeFetcher.fetch('https://raw.githubusercontent.com/owner/repo/main/file.rb')

    assert_equal "def hello\n  puts 'world'\nend", code
  end

  def test_follows_redirects
    stub_request(:get, 'https://raw.githubusercontent.com/owner/repo/main/file.rb')
      .to_return(status: 302, headers: { 'Location' => 'https://raw.githubusercontent.com/owner/repo/main/file2.rb' })
    stub_request(:get, 'https://raw.githubusercontent.com/owner/repo/main/file2.rb')
      .to_return(body: 'redirected content', status: 200)

    code = Jekyll::GitHubCode::CodeFetcher.fetch('https://raw.githubusercontent.com/owner/repo/main/file.rb')

    assert_equal 'redirected content', code
  end

  def test_raises_on_not_found
    stub_request(:get, 'https://raw.githubusercontent.com/owner/repo/main/missing.rb')
      .to_return(status: 404, body: 'Not Found')

    assert_raises(Jekyll::GitHubCode::CodeFetcher::FetchError) do
      Jekyll::GitHubCode::CodeFetcher.fetch('https://raw.githubusercontent.com/owner/repo/main/missing.rb')
    end
  end
end

class CodeRendererTest < Minitest::Test
  def test_renders_code_block_html
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/README.md')
    code = "# Hello World\n\nThis is a test."
    renderer = Jekyll::GitHubCode::CodeRenderer.new(ref, code)

    html = renderer.render

    assert_includes html, 'github-code-block'
    assert_includes html, 'README.md'
    assert_includes html, 'https://github.com/r0x0d/toolbox-dev/blob/main/README.md'
    assert_includes html, '# Hello World'
    assert_includes html, 'language-markdown'
  end

  def test_escapes_html_in_code
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/index.html')
    code = '<div>Hello</div>'
    renderer = Jekyll::GitHubCode::CodeRenderer.new(ref, code)

    html = renderer.render

    assert_includes html, '&lt;div&gt;Hello&lt;/div&gt;'
    refute_includes html, '<div>Hello</div>'
  end

  def test_extracts_line_range
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/file.py#L2-L3')
    code = "line 1\nline 2\nline 3\nline 4\n"
    renderer = Jekyll::GitHubCode::CodeRenderer.new(ref, code)

    html = renderer.render

    assert_includes html, 'line 2'
    assert_includes html, 'line 3'
    refute_includes html, 'line 1'
    refute_includes html, 'line 4'
  end

  def test_shows_line_range_in_header
    ref = Jekyll::GitHubCode::GitHubReference.new('r0x0d/toolbox-dev/blob/main/file.py#L5-L15')
    code = "line\n" * 20
    renderer = Jekyll::GitHubCode::CodeRenderer.new(ref, code)

    html = renderer.render

    assert_includes html, '(L5-L15)'
  end

  def test_detects_python_language
    ref = Jekyll::GitHubCode::GitHubReference.new('owner/repo/blob/main/script.py')
    renderer = Jekyll::GitHubCode::CodeRenderer.new(ref, '')

    html = renderer.render

    assert_includes html, 'language-python'
  end

  def test_detects_ruby_language
    ref = Jekyll::GitHubCode::GitHubReference.new('owner/repo/blob/main/script.rb')
    renderer = Jekyll::GitHubCode::CodeRenderer.new(ref, '')

    html = renderer.render

    assert_includes html, 'language-ruby'
  end

  def test_detects_containerfile_as_dockerfile
    ref = Jekyll::GitHubCode::GitHubReference.new('owner/repo/blob/main/fedora.Containerfile')
    renderer = Jekyll::GitHubCode::CodeRenderer.new(ref, '')

    html = renderer.render

    assert_includes html, 'language-dockerfile'
  end

  def test_includes_copy_button
    ref = Jekyll::GitHubCode::GitHubReference.new('owner/repo/blob/main/file.js')
    renderer = Jekyll::GitHubCode::CodeRenderer.new(ref, 'const x = 1;')

    html = renderer.render

    assert_includes html, 'github-code-copy'
    assert_includes html, 'type="button"'
    assert_includes html, 'Copy code'
  end

  def test_includes_github_icon
    ref = Jekyll::GitHubCode::GitHubReference.new('owner/repo/blob/main/file.js')
    renderer = Jekyll::GitHubCode::CodeRenderer.new(ref, '')

    html = renderer.render

    assert_includes html, 'github-icon'
  end
end

class LiquidTagIntegrationTest < Minitest::Test
  def setup
    WebMock.enable!
  end

  def teardown
    WebMock.disable!
  end

  def test_tag_renders_github_code
    stub_request(:get, 'https://raw.githubusercontent.com/r0x0d/toolbox-dev/main/README.md')
      .to_return(body: "# Toolbox Dev\n\nAwesome project!", status: 200)

    template = Liquid::Template.parse('{% github_code r0x0d/toolbox-dev/blob/main/README.md %}')
    result = template.render

    assert_includes result, 'github-code-block'
    assert_includes result, 'README.md'
    assert_includes result, '# Toolbox Dev'
  end

  def test_tag_handles_line_ranges
    # Use letters to avoid substring matching issues (e.g., "Line 10" contains "Line 1")
    letters = ('A'..'Z').to_a
    code_content = (1..20).map { |n| "Row_#{letters[n - 1]}" }.join("\n")
    stub_request(:get, 'https://raw.githubusercontent.com/r0x0d/toolbox-dev/main/file.py')
      .to_return(body: code_content, status: 200)

    template = Liquid::Template.parse('{% github_code r0x0d/toolbox-dev/blob/main/file.py#L5-L10 %}')
    result = template.render

    assert_includes result, 'Row_E'  # Line 5
    assert_includes result, 'Row_J'  # Line 10
    refute_includes result, 'Row_A'  # Line 1
    refute_includes result, 'Row_T'  # Line 20
  end

  def test_tag_shows_error_on_invalid_reference
    template = Liquid::Template.parse('{% github_code invalid-ref %}')
    result = template.render

    assert_includes result, 'github-code-error'
    assert_includes result, 'Invalid GitHub reference'
  end

  def test_tag_shows_error_on_fetch_failure
    stub_request(:get, 'https://raw.githubusercontent.com/r0x0d/missing/main/file.md')
      .to_return(status: 404)

    template = Liquid::Template.parse('{% github_code r0x0d/missing/blob/main/file.md %}')
    result = template.render

    assert_includes result, 'github-code-error'
  end
end
