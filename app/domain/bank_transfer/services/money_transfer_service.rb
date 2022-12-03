module BankTransfer
  module MoneyTransferService
    class MoneyTransferService
      def initialize(transfer_dto)
        @transfer_dto = transfer_dto
        @accounts_repository = AccountsRepository
      end

      def transfer(transfer_dto)
        transfer_strategy.transfer(transfer_dto)
      end

      private

      def accounts_from_same_bank?
        account_from = @accounts_repository.find(transfer_dto.account_from_id)
        account_to = @accounts_repository.find(transfer_dto.account_to_id)

        account_from.customer.bank_id == account_to.customer.bank_id
      end

      def transfer_strategy
        return TransferStrategy::SameBankStrategy if accounts_from_same_bank?
        TransferStrategy::DifferentBankStrategy
      end
    end
  end
end
