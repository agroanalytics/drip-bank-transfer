# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      module Constraints
        class InvalidAmount < StandardError
          def initialize
            message = 'Invalid transfer amount'
            super(message)
          end
        end
      end
    end
  end
end
