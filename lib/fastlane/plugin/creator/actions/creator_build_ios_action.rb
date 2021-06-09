require 'fastlane/action'
require_relative '../helper/creator_helper'

module Fastlane
  module Actions
    class CreatorBuildIosAction < Action
      def self.run(params)
        UI.message("Building project for ios with creator")

        (!params.nil? && !params[:project_path].nil?) || UI.user_error!("Mandatory parameter :project_path not specified")

        #
        # Params
        #
        project_path = params[:project_path]
        # team_id = params[:team_id]
        # bundle_id = params[:bundle_id]
        # target_os = params[:min_target_ios]

        creator_bin = Helper::CreatorHelper.ensure_creator_exists
        if creator_bin != nil
          UI.message("Creator exists!")
        else
          UI.message("Creator does not exists!")
        end

        cmd = "#{creator_bin} build apple --release --target=aarch64-apple-ios"
        if system("cd #{project_path} && #{cmd}")
          UI.message("Success!")
        else
          UI.user_error!("Failed to build project with creator")
        end
      end

      def self.description
        "Mobile build framework for rust-lang"
      end

      def self.authors
        ["David Ackerman"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :project_path,
                                       env_name: 'CREATOR_PROJECT_PATH',
                                       description: 'Path to Rust project with Cargo.toml',
                                       default_value: Helper::CreatorHelper.find_default_rust_project,
                                       optional: false),
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
