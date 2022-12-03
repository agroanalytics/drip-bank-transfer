# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      module Operations
        class DeductFixedAmountFromSenderOperation
          AMOUNT_TO_DEDUCT_IN_REAIS = 5

          def initialize(credit_operation)
            @credit_operation = credit_operation
          end

          def perform
            result = CreditOperation.new(
              account_from: (@credit_operation.account_from - AMOUNT_TO_DEDUCT_IN_REAIS),
              account_to: @credit_operation.account_to
            )
          end
        end
      end
    end
  end
end
