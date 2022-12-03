# frozen_string_literal: true

module UseCase
  module BankTransfer
    class TransferMoney
      def initialize(overrides = {})
        @money_transfer_service = overrides.fetch(:money_transfer_service) do
          ::BankTransfer::Services::MoneyTransferService
        end
      end

      def transfer(account_from_id, account_to_id, amount)
        transfer_dto = to_dto(account_from_id, account_to_id, amount)
        @money_transfer_service.new(transfer_dto).transfer
      end

      private

      def to_dto(account_from_id, account_to_id, amount_to_transfer)
        ::BankTransfer::Dtos::Transfer.new(
          account_from_id:,
          account_to_id:,
          amount_to_transfer:
        )
      end
    end
  end
end
