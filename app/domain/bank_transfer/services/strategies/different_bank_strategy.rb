module BankTransfer
  module Services
    module Strategies
      class DifferentBankStrategy < BaseTransferStrategy
        def initialize(transfer_dto)
          super
          @constraints = [
            Constraints::LimitShouldBeLowerThan5000
          ]
          @operations_in_order = [
            Operations::DeductComissionOperation
          ]
        end
      end
    end
  end
end
