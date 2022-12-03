require 'rails_helper'

describe BankTransfer::Services::Strategies::Steps::ValidateWalletOperation do
  context 'when validating wallet operation' do
    it 'returns true if both sender and receiver accounts have positive* values at end of operation' do
      sender_account_amt = 1000
      receiver_account_amt = 0
      sender_account = BankTransfer::Entities::Account.new(
        amount: sender_account_amt
      )
      receiver_account = BankTransfer::Entities::Account.new(
        amount: receiver_account_amt
      )
      transfer = instance_double(
        BankTransfer::Dtos::Transfer,
        account_id_from: 'account-from-uuid',
        account_id_to: 'account-to-uuid'
      )
      operation_with_positive_result = BankTransfer::Dtos::CreditOperation.new(
        account_from: -100, account_to: 1000
      )
      operation_with_zeroed_sender_result = BankTransfer::Dtos::CreditOperation.new(
        account_from: -1000, account_to: 995
      )
      operation_with_zeroed_receiver_result = BankTransfer::Dtos::CreditOperation.new(
        account_from: 0, account_to: 0
      )
      accounts_repository = class_double(BankTransfer::Repositories::AccountsRepository)
      allow(accounts_repository).to receive(:find).with('account-from-uuid').and_return sender_account
      allow(accounts_repository).to receive(:find).with('account-to-uuid').and_return receiver_account

      result_1 = described_class.new(operation_with_positive_result, transfer, accounts_repository: accounts_repository).perform
      result_2 = described_class.new(operation_with_zeroed_sender_result, transfer, accounts_repository: accounts_repository).perform
      result_3 = described_class.new(operation_with_zeroed_receiver_result, transfer, accounts_repository: accounts_repository).perform

      expect(result_1).to be true
      expect(result_2).to be true
      expect(result_3).to be true
    end

    it 'returns false if sender account have negative value at end of operation' do
      sender_account = BankTransfer::Entities::Account.new(
        amount: 1000
      )
      receiver_account = BankTransfer::Entities::Account.new(
        amount: 0
      )
      transfer = instance_double(
        BankTransfer::Dtos::Transfer,
        account_id_from: 'account-from-uuid',
        account_id_to: 'account-to-uuid'
      )
      operation_with_negative_sender_result = BankTransfer::Dtos::CreditOperation.new(
        account_from: -1001, account_to: 995
      )
      accounts_repository = class_double(BankTransfer::Repositories::AccountsRepository)
      allow(accounts_repository).to receive(:find).with('account-from-uuid').and_return sender_account
      allow(accounts_repository).to receive(:find).with('account-to-uuid').and_return receiver_account
      subject = described_class.new(operation_with_negative_sender_result, transfer, accounts_repository: accounts_repository)

      expect { subject.perform }.to raise_error(RuntimeError)
    end

    it 'returns false if receiver account have negative value at end of operation' do
      sender_account = BankTransfer::Entities::Account.new(
        amount: 1000
      )
      receiver_account = BankTransfer::Entities::Account.new(
        amount: 666
      )
      transfer = instance_double(
        BankTransfer::Dtos::Transfer,
        account_id_from: 'account-from-uuid',
        account_id_to: 'account-to-uuid'
      )
      operation_with_negative_receiver_result = BankTransfer::Dtos::CreditOperation.new(
        account_from: 1000, account_to: -667
      )
      accounts_repository = class_double(BankTransfer::Repositories::AccountsRepository)
      allow(accounts_repository).to receive(:find).with('account-from-uuid').and_return sender_account
      allow(accounts_repository).to receive(:find).with('account-to-uuid').and_return receiver_account
      subject = described_class.new(operation_with_negative_receiver_result, transfer, accounts_repository: accounts_repository)

      expect { subject.perform }.to raise_error(RuntimeError)
    end
  end
end
