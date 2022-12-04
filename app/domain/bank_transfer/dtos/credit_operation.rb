# frozen_string_literal: true

module BankTransfer
  module Dtos
    class CreditOperation
      attr_reader :account_from, :account_to, :bank_commission

      def initialize(account_from:, account_to:, bank_commission: 0)
        @account_from = account_from
        @account_to = account_to
        @bank_commission = bank_commission
      end
    end
  end
end
