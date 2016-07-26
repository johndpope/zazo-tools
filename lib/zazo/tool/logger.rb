require 'zazo/tool/logger/http'

module Zazo
  module Tool

    #
    # Component for logging to different sources
    #

    class Logger
      class Config
        attr_reader :logstash_logger

        attr_accessor :local_enabled, :rollbar_enabled, :logstash_enabled,
                      :logstash_host, :logstash_port, :logstash_username, :logstash_password,
                      :project_name, :environment

        def initialize
          set_sources_settings
          set_logstash_settings
          set_logstash_logger
          update_by_sources
        end

        def update_by_sources
          self.local_enabled = false unless Object.const_defined?('Rails')
          self.rollbar_enabled = false unless Object.const_defined?('Rollbar')
        end

        def set_logstash_logger
          @logstash_logger = Zazo::Tool::Logger::Http.new(
            self.logstash_host, self.logstash_port,
            auth: { username: self.logstash_username,
                    password: self.logstash_password })
        end

        private

        def set_sources_settings
          self.local_enabled = true
          self.rollbar_enabled = true
          self.logstash_enabled = false
        end

        def set_logstash_settings
          self.project_name = 'default'
          self.logstash_host = 'localhost'
          self.logstash_port = 9900
          self.environment = Object.const_defined?('Rails') ? Rails.env : 'undefined'
        end
      end

      class << self
        #
        # configuration
        #

        def config
          @config ||= Config.new
        end

        def configure
          yield(config)
          config.update_by_sources
          config.set_logstash_logger
        end

        #
        # logging
        #

        def info(*args)
          logging(*([:info] + args))
        end

        def debug(*args)
          logging(*([:debug] + args))
        end

        def error(*args)
          logging(*([:error] + args))
        end

        private

        def logging(level, context, message, settings = {})
          tag = get_class_name(context)
          logging_local(level, tag, message) if config.local_enabled
          logging_logstash(level, tag, message) if config.logstash_enabled
          logging_rollbar(level, tag, message) if config.rollbar_enabled && settings[:rollbar]
        end

        def logging_local(level, tag, message)
          Rails.logger.tagged(tag) { Rails.logger.send(level, message) }
        end

        def logging_rollbar(level, tag, message)
          Rollbar.send(level, "[#{tag}] #{message}")
        end

        def logging_logstash(level, tag, message)
          config.logstash_logger.perform_async(
            project: config.project_name,
            environment: config.environment,
            level: level, tag: tag,
            message: message)
        end

        def get_class_name(context)
          context.instance_of?(Class) ? context.name : context.class.name
        end
      end
    end

  end
end
