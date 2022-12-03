# frozen_string_literal: true

module BankTransfer
  module Services
    class MoneyTransferService
      def initialize(transfer, overrides = {})
        @transfer = transfer
        @accounts_repository = overrides.fetch(:accounts_repository) do
          BankTransfer::Repositories::AccountsRepository
        end
      end

      def transfer
        transfer_strategy.new(@transfer).perform_transfer
      rescue ActiveRecord::RecordNotFound,
             BankTransfer::Services::InvalidOperationException,
             BankTransfer::Services::Strategies::Steps::InvalidWalletOperation,
             BankTransfer::Services::Strategies::Constraints::InvalidAmount => e
        raise InvalidOperationException, e.message
      end

      private

      def accounts_from_same_bank?
        account_from = @accounts_repository.find(@transfer.account_from_id)
        account_to = @accounts_repository.find(@transfer.account_to_id)

        account_from.customer.bank_id == account_to.customer.bank_id
      end

      def transfer_strategy
        return same_bank_strategy if accounts_from_same_bank?

        different_bank_strategy
      end

      def same_bank_strategy
        BankTransfer::Services::Strategies::SameBankStrategy
      end

      def different_bank_strategy
        BankTransfer::Services::Strategies::DifferentBankStrategy
      end
    end

    class InvalidOperationException < StandardError
      def initialize(message)
        message = "Unable to perform transfer operation: #{message}"
        super(message)
      end
    end
  end
end
