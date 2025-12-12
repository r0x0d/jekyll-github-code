# frozen_string_literal: true

module Jekyll
  module GitHubCode
    # Generator that copies the CSS and JS assets to the site
    class Generator < Jekyll::Generator
      safe true
      priority :lowest

      def generate(site)
        # Find the gem's root directory (where assets/ is located)
        gem_root = File.expand_path('../../..', __dir__)
        assets_source = File.join(gem_root, 'assets')

        # Copy CSS file
        css_source = File.join(assets_source, 'css', 'github-code.css')
        if File.exist?(css_source)
          site.static_files << AssetFile.new(
            site,
            assets_source,
            'css',
            'github-code.css'
          )
        end

        # Copy JS file
        js_source = File.join(assets_source, 'js', 'github-code.js')
        if File.exist?(js_source)
          site.static_files << AssetFile.new(
            site,
            assets_source,
            'js',
            'github-code.js'
          )
        end
      end
    end

    # Custom static file class for gem assets
    class AssetFile < Jekyll::StaticFile
      def initialize(site, base, dir, name)
        @site = site
        @base = base
        @dir = dir
        @name = name
        @relative_path = File.join(dir, name)
        @extname = File.extname(name)
        @collection = nil
      end

      def path
        File.join(@base, @dir, @name)
      end

      def destination(dest)
        File.join(dest, 'assets', 'github-code', @dir, @name)
      end

      def write(dest)
        dest_path = destination(dest)
        return false unless File.exist?(path)

        FileUtils.mkdir_p(File.dirname(dest_path))
        FileUtils.cp(path, dest_path)
        true
      end

      def modified?
        true
      end
    end
  end
end
