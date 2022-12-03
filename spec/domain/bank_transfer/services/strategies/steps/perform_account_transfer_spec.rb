# frozen_string_literal: true

require 'rails_helper'

describe BankTransfer::Services::Strategies::Steps::PerformAccountTransfer do
  context 'when performing account transfer' do
    it 'sums operated amount on both sender and receiver accounts an returns true upon success' do
      bank = BankTransfer::Entities::Bank.create(name: 'BB')
      sender = BankTransfer::Entities::Customer.create(bank_id: bank.id)
      receiver = BankTransfer::Entities::Customer.create(bank_id: bank.id)
      sender_account = BankTransfer::Entities::Account.create(customer_id: sender.id, amount: 1000)
      receiver_account = BankTransfer::Entities::Account.create(customer_id: sender.id, amount: 500)
      transfer = instance_double(
        BankTransfer::Dtos::Transfer,
        account_from_id: sender_account.id,
        account_to_id: receiver_account.id,
        amount_to_transfer: 595
      )
      credit_operation = BankTransfer::Dtos::CreditOperation.new(
        account_from: -600, account_to: 595
      )

      result = described_class.new(transfer, credit_operation).perform

      expect(sender_account.reload.amount).to eq 400
      expect(receiver_account.reload.amount).to eq 1095
      expect(result).to be true
    end
  end
end
