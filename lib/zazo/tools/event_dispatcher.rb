require 'aws-sdk'

module Zazo
  module Tools
    #
    # Component to dispatching events to AWS SQS worker
    #

    class EventDispatcher
      class Config
        attr_accessor :send_message_enabled, :queue_url, :logger

        def initialize
          @send_message_enabled = true
        end
      end

      class << self
        attr_reader :config

        #
        # configuration
        #

        def configure
          @config ||= Config.new
          yield(config)
        end

        def enable_send_message!
          config.send_message_enabled = true
        end

        def disable_send_message!
          config.send_message_enabled = false
        end

        def send_message_enabled?
          config.send_message_enabled
        end

        #
        # emitting
        #

        def sqs_client
          @sqs_client ||= Aws::SQS::Client.new
        end

        def with_state(state)
          original = send_message_enabled?
          log_message("#{original} => #{state}")
          config.send_message_enabled = state
          yield if block_given?
          log_message("#{state} => #{original}")
          config.send_message_enabled = original
        end

        def build_message(name, params = {})
          name = name.split(':') if name.is_a?(String)
          { name: name,
            triggered_by: 'zazo:api',
            triggered_at: Time.now.utc }.merge(params)
        end

        def emit(name, params = {})
          message = build_message(name, params)
          log_message("attemt to sent message to SQS queue #{config.queue_url}: #{message}")
          if send_message_enabled?
            sqs_client.send_message(queue_url: config.queue_url, message_body: message.to_json)
          else
            log_message("message not sent to SQS because #{self} is disabled")
            {}
          end
        end

        private

        def log_message(message)
          config.logger.info("[#{self}] #{message}") if config.logger
        end
      end
    end
  end
end
