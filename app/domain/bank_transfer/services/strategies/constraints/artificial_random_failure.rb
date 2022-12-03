# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      module Constraints
        class ArtificialRandomFailure
          CHANCE_OF_FAILURE = 0.3

          def initialize(_); end

          def valid?
            raise SystemFailure if Rails.env != 'test' && fail?

            true
          end

          private

          def fail?
            Random.rand <= CHANCE_OF_FAILURE
          end
        end
      end
    end
  end
end
