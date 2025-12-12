# Jekyll GitHub Code

[![Gem Version](https://badge.fury.io/rb/jekyll-github-code.svg)](https://badge.fury.io/rb/jekyll-github-code)
[![Ruby](https://github.com/r0x0d/jekyll-github-code/actions/workflows/ruby.yml/badge.svg)](https://github.com/r0x0d/jekyll-github-code/actions/workflows/ruby.yml)

A Jekyll plugin that lets you embed code from GitHub repositories directly in your blog posts. Perfect for technical blogs, especially those using the [Chirpy theme](https://github.com/cotes2020/jekyll-theme-chirpy).

## Features

- **Embed full files** from any public GitHub repository
- **Line range support** - show only specific lines (`#L5-L15`)
- **Automatic syntax highlighting** based on file extension
- **Copy button** for easy code copying
- **Clickable filename** links directly to GitHub
- **Dark/light mode support** compatible with Chirpy theme
- **Graceful error handling** with informative messages

## Installation

Add this line to your Jekyll site's `Gemfile`:

```ruby
gem 'jekyll-github-code'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install jekyll-github-code
```

### Configure Jekyll

Add the plugin to your `_config.yml`:

```yaml
plugins:
  - jekyll-github-code
```

### Include the Assets

The plugin automatically copies CSS and JS files to your site's `_site/assets/github-code/` directory during build.

Add the stylesheet to your layout's `<head>`:

```html
<link rel="stylesheet" href="/assets/github-code/css/github-code.css">
```

Add the JavaScript before the closing `</body>` tag (required for the copy button):

```html
<script src="/assets/github-code/js/github-code.js"></script>
```

#### For Chirpy Theme

If you're using the Chirpy theme, you can alternatively:

1. Copy the CSS content to your custom styles
2. Or add the link tag to `_includes/head.html`
3. Add the script tag to `_layouts/default.html` before `</body>`

## Usage

### Basic Usage - Full File

```liquid
{% github_code owner/repo/blob/branch/path/to/file.py %}
```

**Example:**

```liquid
{% github_code r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile %}
```

### With Line Range

Show only specific lines:

```liquid
{% github_code owner/repo/blob/branch/path/to/file.py#L5-L15 %}
```

**Example:**

```liquid
{% github_code r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile#L5-L15 %}
```

### Single Line

```liquid
{% github_code owner/repo/blob/branch/path/to/file.py#L10 %}
```

### Full GitHub URL

You can also use the complete GitHub URL:

```liquid
{% github_code https://github.com/owner/repo/blob/branch/path/to/file.py %}
```

## Supported Languages

The plugin automatically detects the language from the file extension:

| Extension | Language |
|-----------|----------|
| `.rb` | Ruby |
| `.py` | Python |
| `.js` | JavaScript |
| `.ts` | TypeScript |
| `.yml`, `.yaml` | YAML |
| `.md` | Markdown |
| `.sh` | Bash |
| `.Dockerfile`, `.Containerfile` | Dockerfile |
| Others | Uses extension as-is |

## Theme Support

The plugin supports both light and dark themes out of the box, compatible with multiple theme systems:

### Supported Theme Selectors

- `[data-mode="light"]` - Chirpy theme
- `[data-theme="light"]` - Common theme attribute
- `.light` - Class-based themes
- `@media (prefers-color-scheme: light)` - System preference

The default is dark theme. Light theme is automatically applied when any of the above selectors match.

### CSS Variables

You can customize the appearance by overriding CSS variables:

```css
.github-code-block {
  --github-code-bg: #0d1117;
  --github-code-header-bg: #161b22;
  --github-code-border: #30363d;
  --github-code-text: #e6edf3;
  --github-code-text-secondary: #8b949e;
  --github-code-link: #58a6ff;
  --github-code-link-hover: #79c0ff;
  --github-code-copy-hover: #238636;
}
```

Light theme values are automatically applied, but you can also customize them:

```css
[data-mode="light"] .github-code-block {
  --github-code-bg: #ffffff;
  --github-code-header-bg: #f6f8fa;
  --github-code-border: #d0d7de;
  --github-code-text: #1f2328;
  --github-code-text-secondary: #656d76;
  --github-code-link: #0969da;
  --github-code-link-hover: #0550ae;
}
```

## Development

After checking out the repo, run `bundle install` to install dependencies.

### Running Tests

```bash
bundle exec rake test
```

Or run tests directly:

```bash
bundle exec ruby -Ilib -Itest test/github_code_test.rb
```

### Building the Gem

```bash
bundle exec rake build
```

### Installing Locally

```bash
bundle exec rake install
```

### Releasing

To release a new version:

1. Update the version number in `lib/jekyll-github-code/version.rb`
2. Update `CHANGELOG.md`
3. Run `bundle exec rake release`

## Demo

Open `demo.html` in your browser to see a preview of the rendered output with different examples.

## How It Works

1. The Liquid tag parses the GitHub reference (owner/repo/branch/path)
2. Fetches the raw file content from `raw.githubusercontent.com`
3. Extracts the specified line range (if provided)
4. Escapes HTML entities in the code
5. Renders a styled code block with:
   - GitHub icon and clickable filename
   - Copy button
   - Syntax-highlighted code

## Caching

The plugin fetches code at build time. For production, consider:

- Using Jekyll caching plugins
- Setting up GitHub Actions with caching
- Pre-generating static includes for frequently used snippets

## Error Handling

If the code cannot be fetched (e.g., 404, network error), the plugin displays a styled error message instead of breaking the build.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/r0x0d/jekyll-github-code.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for new functionality
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](./LICENSE).
