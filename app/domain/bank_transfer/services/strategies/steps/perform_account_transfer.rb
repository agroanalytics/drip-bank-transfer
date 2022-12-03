# frozen_string_literal: true

module BankTransfer
  module Services
    module Strategies
      module Steps
        class PerformAccountTransfer
          def initialize(transfer, credit_operation, _overrides = {})
            @credit_operation = credit_operation
            @transfer = transfer
            @accounts_repository = BankTransfer::Repositories::AccountsRepository
          end

          def perform
            perform_account_transfer

            true
          end

          private

          def perform_account_transfer
            ActiveRecord::Base.transaction do
              account_from.amount = account_from.amount += @credit_operation.account_from
              account_to.amount = account_to.amount += @credit_operation.account_to

              account_from.save
              account_to.save
            end
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
