# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      class DifferentBankStrategy < BaseTransferStrategy
        def initialize(transfer, overrides = {})
          super(transfer, overrides)
          @constraints = [
            Constraints::TransferAmountValid,
            Constraints::ArtificialRandomFailure
          ]
          @operations_in_order = [
            Operations::DeductFixedAmountFromSenderOperation
          ]
        end
      end
    end
  end
end
