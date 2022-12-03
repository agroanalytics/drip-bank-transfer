# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      module Steps
        class ValidateWalletOperation
          def initialize(transfer, credit_operation, overrides = {})
            @transfer = transfer
            @credit_operation = credit_operation
            @accounts_repository = overrides.fetch(:accounts_repository) do
              BankTransfer::Repositories::AccountsRepository
            end
          end

          def perform
            raise InvalidWalletOperation unless valid_wallet_operation?

            true
          end

          private

          def valid_wallet_operation?
            return false if account_from.id == account_to.id

            # Total credit values can be either positive or negative, thus summing always will do the correct math
            return false if (account_from.amount + @credit_operation.account_from).negative?
            return false if (account_to.amount + @credit_operation.account_to).negative?

            true
          end

          def account_from
            @account_from ||= @accounts_repository.find(@transfer.account_from_id)
          end

          def account_to
            @account_to ||= @accounts_repository.find(@transfer.account_to_id)
          end
        end
      end
    end
  end
end
