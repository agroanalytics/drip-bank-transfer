# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      module Steps
        class PerformAccountTransfer
          def initialize(transfer, credit_operation, _overrides = {})
            @transfer = transfer
            @credit_operation = credit_operation
            @accounts_repository = BankTransfer::Repositories::AccountsRepository
          end

          def perform
            perform_account_transfer

            true
          end

          private

          def perform_account_transfer
            ActiveRecord::Base.transaction do
              wallet_from_operation, wallet_to_operation, bank_wallet = register_operation_in_wallet(account_from, account_to, @credit_operation)
              account_from.amount = account_from.amount += @credit_operation.account_from
              account_to.amount = account_to.amount += @credit_operation.account_to

              wallet_from_operation.save
              wallet_to_operation.save
              bank_wallet.save if bank_wallet.amount > 0
              account_from.save
              account_to.save
            end
          end

          def account_from
            @account_from ||= @accounts_repository.find(@transfer.account_from_id)
          end

          def account_to
            @account_to ||= @accounts_repository.find(@transfer.account_to_id)
          end

          def register_operation_in_wallet(account_from, account_to, credit_operation)
            [
              BankTransfer::Entities::Wallet.new(entity_id: account_from.id, amount: credit_operation.account_from),
              BankTransfer::Entities::Wallet.new(entity_id: account_to.id, amount: credit_operation.account_to),
              BankTransfer::Entities::Wallet.new(entity_id: account_from.customer.bank_id, amount: credit_operation.bank_commission),
            ]
          end
        end
      end
    end
  end
end
