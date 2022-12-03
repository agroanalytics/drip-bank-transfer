# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      module Steps
        class InvalidWalletOperation < StandardError
          def initialize
            message = 'Invalid operation due to insuficient money amount'
            super(message)
          end
        end
      end
    end
  end
end
