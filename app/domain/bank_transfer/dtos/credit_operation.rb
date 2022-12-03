module BankTransfer
  module Dtos
    class CreditOperation
      attr_reader :account_from, :account_to

      def initialize(account_from:, account_to:)
        @account_from = account_from
        @account_to = account_to
      end
    end
  end
end
