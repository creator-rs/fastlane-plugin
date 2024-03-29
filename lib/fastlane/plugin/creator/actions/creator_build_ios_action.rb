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
        profile_path = params[:profile_path]
        team_id = params[:team_id]
        identity = params[:identity]

        creator_bin = Helper::CreatorHelper.ensure_creator_exists
        if !creator_bin.nil?
          UI.message("Creator exists!")
        else
          UI.message("Creator does not exists!")
        end

        cmd = "#{creator_bin} build apple --release --target=aarch64-apple-ios"
        cmd += " --profile-path=#{profile_path}"
        cmd += " --team-identifier=#{team_id}"
        cmd += " --identity=#{identity}"
        if system("cd #{project_path} && #{cmd}")
          UI.message("Success!")
        else
          UI.user_error!("Failed to build project with creator")
        end
      end

      def self.description
        "Builds ipa file from rust project"
      end

      def self.authors
        ["David Ackerman"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :project_path,
                                       env_name: 'CREATOR_PROJECT_PATH',
                                       description: 'Path to Rust project with Cargo.toml',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :profile_path,
                                       env_name: 'CREATOR_PROFILE_PATH',
                                       description: 'Apple Profile path for signing',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :team_id,
                                       env_name: 'CREATOR_TEAM_ID',
                                       description: 'Apple Team ID for signing',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :identity,
                                       env_name: 'CREATOR_IDENTITY',
                                       description: 'Apple identity for signing',
                                       optional: false)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        [:ios].include?(platform)
      end
    end
  end
end
