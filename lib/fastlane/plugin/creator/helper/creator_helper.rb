require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class CreatorHelper
      def self.ensure_creator_exists
        if !self.which("creator").nil?
          return "creator"
        elsif !self.which("cargo-creator").nil?
          return "cargo-creator"
        else
          return nil
        end
      end

      # Cross-platform way of finding an executable in the $PATH.
      #
      #   which('ruby') #=> /usr/bin/ruby
      def self.which(cmd)
        exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
          exts.each do |ext|
            exe = File.join(path, "#{cmd}#{ext}")
            return exe if File.executable?(exe) && !File.directory?(exe)
          end
        end
        nil
      end

      #
      # Find any existing Rust project
      #
      def self.find_default_rust_project
        Dir["./*.toml"].last || nil
      end
    end
  end
end
