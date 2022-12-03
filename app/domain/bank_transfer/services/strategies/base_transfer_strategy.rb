module UseCase
  module Drip
    module TransferStrategy
      class BaseTransferStrategy
        def initialize(transfer_dto)
          @transfer_dto = transfer_dto
          @account_repository = AccountRepository
          @constraints = []
          @operations_in_order = []
        end

        def transfer
          @total_credit = CreditCalculator
            .new(@transfer_dto, @operations_in_order)
            .calculate_total_credit

          transfer_steps_in_order.each { |step| step.perform }
        end

        private

        def transfer_steps_in_order
          [
            ValidateConstraints.new(@transfer_dto, @constraints),
            ValidateWalletOperation.new(@total_credit, @transfer_dto),
            PerformAccountTransfer.new(@total_credit, @transfer_dto)
          ]
        end
      end
    end
  end
end
