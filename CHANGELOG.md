# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-12-12

### Fixed
- Automatic asset generation (CSS and JS copied to `_site/assets/github-code/`)



## [0.1.0] - 2025-12-12

### Added

- Initial release
- `{% github_code %}` Liquid tag for embedding GitHub code
- Support for full file embedding
- Support for line range selection (`#L5-L15`)
- Support for single line selection (`#L10`)
- Automatic language detection based on file extension
- Copy-to-clipboard button
- Clickable filename linking to GitHub
- Dark and light theme support (multiple theme systems supported)
- Compatible with Jekyll Chirpy theme
- Comprehensive test suite
