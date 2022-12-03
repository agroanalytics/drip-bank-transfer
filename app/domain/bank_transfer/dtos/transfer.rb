# frozen_string_literal: true

module BankTransfer
  module Dtos
    class Transfer
      attr_reader :account_from_id, :account_to_id, :amount_to_transfer

      def initialize(account_from_id:, account_to_id:, amount_to_transfer:)
        @account_from_id = account_from_id
        @account_to_id = account_to_id
        @amount_to_transfer = amount_to_transfer
      end
    end
  end
end
