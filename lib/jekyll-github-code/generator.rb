# frozen_string_literal: true

module Jekyll
  module GithubCode
    class CodeStyleGenerator < Jekyll::Generator
      safe true
      priority :low

      def generate(site)
        content = File.read(File.join(File.dirname(__FILE__), "..", "..", "assets", "css", "github-code.css"))

        # Create a static file for the CSS
        site.static_files << CodeStyleFile.new(site, content)
      end
    end

    class JavaScriptGenerator < Jekyll::Generator
      safe true
      priority :low

      def generate(site)
        content = File.read(File.join(File.dirname(__FILE__), "..", "..", "assets", "js", "github-code.js"))

        # Create a static file for the CSS
        site.static_files << JavaScriptFile.new(site, content)
      end
    end

    class CodeStyleFile < Jekyll::StaticFile
      def initialize(site, content)
        @site = site
        @content = content
        @relative_path = "/assets/css/github-code.css"
        @extname = ".css"
        @name = "github-code.css"
        @dir = "/assets/css"
      end

      def write(dest)
        dest_path = File.join(dest, @relative_path)
        FileUtils.mkdir_p(File.dirname(dest_path))
        File.write(dest_path, @content)
        true
      end

      def path
        @relative_path
      end

      def relative_path
        @relative_path
      end
    end

    class JavaScriptFile < Jekyll::StaticFile
      def initialize(site, content)
        @site = site
        @content = content
        @relative_path = "/assets/js/github-code.js"
        @extname = ".js"
        @name = "github-code.js"
        @dir = "/assets/js"
      end

      def write(dest)
        dest_path = File.join(dest, @relative_path)
        FileUtils.mkdir_p(File.dirname(dest_path))
        File.write(dest_path, @content)
        true
      end

      def path
        @relative_path
      end

      def relative_path
        @relative_path
      end
    end
  end
end
