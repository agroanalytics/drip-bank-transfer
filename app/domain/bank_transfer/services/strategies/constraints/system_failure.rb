# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      module Constraints
        class SystemFailure < StandardError
          def initialize
            message = 'System failed'
            super(message)
          end
        end
      end
    end
  end
end
