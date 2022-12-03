# frozen_string_literal: true

module UseCase
  module BankTransfer
    class TransferMoney
      def initialize(_account_from_id, _account_to_id, _amount_to_transfer)
        @money_transfer_service = overrides.fetch(:money_transfer_service) do
          BankTransfer::Services::MoneyTransferService
        end
      end

      def transfer(account_from_id, account_to_id, amount_to_transfer)
        transfer_dto = to_dto(account_from_id, account_to_id, amount_to_transfer)
        @money_transfer_service.new(transfer_dto).transfer
      end

      private

      def to_dto(account_from_id, account_to_id, amount_to_transfer)
        TransferDto.new(account_from_id, account_to_id, amount_to_transfer)
      end
    end
  end
end
