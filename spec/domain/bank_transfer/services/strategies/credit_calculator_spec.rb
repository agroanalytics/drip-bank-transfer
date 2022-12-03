# frozen_string_literal: true

require 'rails_helper'

describe BankTransfer::Services::Strategies::CreditCalculator do
  context 'when calculating transfer result from a account to other' do
    it 'applies operations to a given transfer input' do
      transfer = BankTransfer::Dtos::Transfer.new(
        account_from_id: 'account-id-from',
        account_to_id: 'account-id-to',
        amount_to_transfer: 1000
      )
      operations = [FakeOperation1, FakeOperation2]

      result = described_class.new(transfer, operations).calculate_total_credit

      expect(result.account_from).to eq(-1070.0)
      expect(result.account_to).to eq 445
    end
  end

  class FakeOperation1
    def initialize(credit_operation)
      @credit_operation = credit_operation
    end

    def perform
      result = BankTransfer::Dtos::CreditOperation.new(
        account_from: (@credit_operation.account_from * 1.02),
        account_to: @credit_operation.account_to
      )
    end
  end

  class FakeOperation2
    def initialize(credit_operation)
      @credit_operation = credit_operation
    end

    def perform
      result = BankTransfer::Dtos::CreditOperation.new(
        account_from: (@credit_operation.account_from - 50),
        account_to: (@credit_operation.account_to - 555)
      )
    end
  end
end
