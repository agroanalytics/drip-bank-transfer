# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      class CreditCalculator
        def initialize(transfer, operations)
          @transfer = transfer
          @operations_in_order = operations
        end

        def calculate_total_credit
          amount_to_credit = BankTransfer::Dtos::CreditOperation.new(
            account_from: -@transfer.amount_to_transfer, account_to: @transfer.amount_to_transfer
          )

          @operations_in_order.each do |operation|
            amount_to_credit = operation.new(amount_to_credit).perform
          end

          amount_to_credit
        end
      end
    end
  end
end
