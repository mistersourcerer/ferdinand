# frozen_string_literal: true

require "zeitwerk"

module Ferdinand
  module Infra
    def self.setup
      @loader ||= Zeitwerk::Loader.for_gem

      if ENV.fetch("FERDINAND_ENVIRONMENT", "").downcase == "dev"
        @loader.enable_reloading
      end
      @loader.tap { |l| l.setup }
    end

    def self.reload
      (@loader || setup).reload
    end

    def self.root
      @root ||= File.expand_path("../../", __FILE__)
    end
  end
end

Ferdinand::Infra.setup
