# frozen_string_literal: true

require 'rails_helper'

describe BankTransfer::Services::Strategies::Constraints::TransferAmountValid do
  context 'when evaluating whether transfer is valid' do
    it 'returns true when amount is lower than 5000 and greater than 0' do
      transfer_1 = BankTransfer::Dtos::Transfer.new(
        account_from_id: 'account-from-uuid',
        account_to_id: 'account-to-uuid',
        amount_to_transfer: 4999.99
      )
      transfer_2 = BankTransfer::Dtos::Transfer.new(
        account_from_id: 'account-from-uuid',
        account_to_id: 'account-to-uuid',
        amount_to_transfer: 0.01
      )

      expect(described_class.new(transfer_1)).to be_valid
      expect(described_class.new(transfer_2)).to be_valid
    end

    it 'throws an exception when amount is lower than 0' do
      transfer = BankTransfer::Dtos::Transfer.new(
        account_from_id: 'account-from-uuid',
        account_to_id: 'account-to-uuid',
        amount_to_transfer: -1
      )

      expect { described_class.new(transfer).valid? }.to raise_error(invalid_amount_exception)
    end

    it 'throws an exception when amount is greater than 5000' do
      transfer = BankTransfer::Dtos::Transfer.new(
        account_from_id: 'account-from-uuid',
        account_to_id: 'account-to-uuid',
        amount_to_transfer: 5000.1
      )

      expect { described_class.new(transfer).valid? }.to raise_error(invalid_amount_exception)
    end
  end

  private

  def invalid_amount_exception
    BankTransfer::Services::Strategies::Constraints::InvalidAmount
  end
end
