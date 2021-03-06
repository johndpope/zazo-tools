require 'zazo/controller/interactions/handle_interactor'

module Zazo
  module Controller

    module Interactions
      def handle_interactor(type_settings, interactor, &callback)
        HandleInteractor.new(
          context: self, interactor: interactor,
          type_settings: type_settings, callback: callback).call do |handler|
          handler.render? ? render(handler.response) : handler.result
        end
      end

      def interactor_params(*keys)
        params.slice(*keys).merge(user: current_user) rescue {}
      end
    end

  end
end
