# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      class BaseTransferStrategy
        def initialize(transfer, overrides = {})
          @transfer = transfer
          @constraints = []
          @operations_in_order = []
          @credit_calculator = overrides.fetch(:credit_calculator) do
            BankTransfer::Services::Strategies::CreditCalculator
          end
        end

        def perform_transfer
          @credit_operation = @credit_calculator
                              .new(@transfer, @operations_in_order)
                              .calculate_total_credit

          transfer_steps_in_order.each(&:perform)
        end

        private

        def transfer_steps_in_order
          [
            Steps::ValidateConstraints.new(@transfer, @constraints),
            Steps::ValidateWalletOperation.new(@transfer, @credit_operation),
            Steps::PerformAccountTransfer.new(@transfer, @credit_operation)
          ]
        end
      end
    end
  end
end
