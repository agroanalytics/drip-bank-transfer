# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      module Steps
        class ValidateWalletOperation
          def initialize(credit_operation, transfer, overrides = {})
            @credit_operation = credit_operation
            @transfer = transfer
            @accounts_repository = overrides.fetch(:accounts_repository) do
              BankTransfer::Repositories::AccountRepository
            end
          end

          def perform
            raise('Invalid operation due to insuficient money amount') unless valid_wallet_operation?

            true
          end

          private

          def valid_wallet_operation?
            # Total credit values can be either positive or negative, thus summing always will do the correct math
            return false if (account_from.amount + @credit_operation.account_from).negative?
            return false if (account_to.amount + @credit_operation.account_to).negative?

            true
          end

          def account_from
            @account_from ||= @accounts_repository.find(@transfer.account_id_from)
          end

          def account_to
            @account_to ||= @accounts_repository.find(@transfer.account_id_to)
          end
        end
      end
    end
  end
end
