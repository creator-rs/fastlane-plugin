require 'fastlane/action'
require_relative '../helper/creator_helper'

module Fastlane
  module Actions
    class CreatorBuildAndroidAction < Action
      def self.run(params)
        UI.message("Building project for android with creator")

        (!params.nil? && !params[:project_path].nil?) || UI.user_error!("Mandatory parameter :project_path not specified")

        #
        # Params
        #
        project_path = params[:project_path]
        sign_key_path = params[:sign_key_path]
        sign_key_pass = params[:sign_key_pass]
        build_envs = params[:build_envs]

        creator_bin = Helper::CreatorHelper.ensure_creator_exists
        if !creator_bin.nil?
          UI.message("Creator exists!")
        else
          UI.message("Creator does not exists!")
        end

        cmd = "#{build_envs} #{creator_bin} build android --release"
        cmd += " --sign-key-path=#{sign_key_path} --sign-key-pass=#{sign_key_pass}"
        if system("cd #{project_path} && #{cmd}")
          UI.message("Success!")
        else
          UI.user_error!("Failed to build project with creator")
        end
      end

      def self.description
        "Builds apk file from rust project"
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
          FastlaneCore::ConfigItem.new(key: :sign_key_path,
                                       env_name: 'CREATOR_SIGN_KEY_PATH',
                                       description: 'Path to the signing key',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :sign_key_pass,
                                       env_name: 'CREATOR_SIGN_KEY_PASS',
                                       description: 'Password for the signing key',
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :build_envs,
                                       env_name: 'CREATOR_BUILD_ENVS',
                                       description: 'Build environment variables',
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        [:android].include?(platform)
      end
    end
  end
end
