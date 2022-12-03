module BankTransfer
  module Services
    module Strategies
      class BaseTransferStrategy
        def initialize(transfer)
          @transfer = transfer
          @constraints = []
          @operations_in_order = []
        end

        def perform_transfer
          @credit_operation = CreditCalculator
            .new(@transfer, @operations_in_order)
            .calculate_credit_operation

          transfer_steps_in_order.each { |step| step.perform }
        end

        private

        def transfer_steps_in_order
          [
            ValidateConstraints.new(@transfer, @constraints),
            ValidateWalletOperation.new(@credit_operation, @transfer),
            PerformAccountTransfer.new(@credit_operation, @transfer)
          ]
        end
      end
    end
  end
end
