# frozen_string_literal: true

require 'rails_helper'

describe BankTransfer::Services::Strategies::Steps::ValidateWalletOperation do
  context 'when validating wallet operation' do
    it 'returns true if both sender and receiver accounts have positive (zero inclusive) values at end of operation' do
      sender_account_amt = 1000
      receiver_account_amt = 0
      sender_account = BankTransfer::Entities::Account.new(
        id: '0472e480-62cf-4303-9c0a-87ed3e2e564e',
        amount: sender_account_amt
      )
      receiver_account = BankTransfer::Entities::Account.new(
        id: 'b3ed8200-fc91-41e6-b9ed-28850c719c7c',
        amount: receiver_account_amt
      )
      transfer = instance_double(
        BankTransfer::Dtos::Transfer,
        account_from_id: 'account-from-uuid',
        account_to_id: 'account-to-uuid'
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

      result_1 = described_class.new(transfer, operation_with_positive_result,
                                     accounts_repository:).perform
      result_2 = described_class.new(transfer, operation_with_zeroed_sender_result,
                                     accounts_repository:).perform
      result_3 = described_class.new(transfer, operation_with_zeroed_receiver_result,
                                     accounts_repository:).perform

      expect(result_1).to be true
      expect(result_2).to be true
      expect(result_3).to be true
    end

    it 'raises InvalidWalletOperation if sender account have negative value at end of operation' do
      sender_account = BankTransfer::Entities::Account.new(
        id: '0472e480-62cf-4303-9c0a-87ed3e2e564e',
        amount: 1000
      )
      receiver_account = BankTransfer::Entities::Account.new(
        id: 'b3ed8200-fc91-41e6-b9ed-28850c719c7c',
        amount: 0
      )
      transfer = instance_double(
        BankTransfer::Dtos::Transfer,
        account_from_id: 'account-from-uuid',
        account_to_id: 'account-to-uuid'
      )
      operation_with_negative_sender_result = BankTransfer::Dtos::CreditOperation.new(
        account_from: -1001, account_to: 995
      )
      accounts_repository = class_double(BankTransfer::Repositories::AccountsRepository)
      allow(accounts_repository).to receive(:find).with('account-from-uuid').and_return sender_account
      allow(accounts_repository).to receive(:find).with('account-to-uuid').and_return receiver_account
      subject = described_class.new(transfer, operation_with_negative_sender_result,
                                    accounts_repository:)

      expect { subject.perform }.to raise_error(invalid_wallet_operation_exception)
    end

    it 'raises InvalidWalletOperation if receiver account have negative value at end of operation' do
      sender_account = BankTransfer::Entities::Account.new(
        id: '0472e480-62cf-4303-9c0a-87ed3e2e564e',
        amount: 1000
      )
      receiver_account = BankTransfer::Entities::Account.new(
        id: 'b3ed8200-fc91-41e6-b9ed-28850c719c7c',
        amount: 666
      )
      transfer = instance_double(
        BankTransfer::Dtos::Transfer,
        account_from_id: 'account-from-uuid',
        account_to_id: 'account-to-uuid'
      )
      operation_with_negative_receiver_result = BankTransfer::Dtos::CreditOperation.new(
        account_from: 1000, account_to: -667
      )
      accounts_repository = class_double(BankTransfer::Repositories::AccountsRepository)
      allow(accounts_repository).to receive(:find).with('account-from-uuid').and_return sender_account
      allow(accounts_repository).to receive(:find).with('account-to-uuid').and_return receiver_account
      subject = described_class.new(transfer, operation_with_negative_receiver_result,
                                    accounts_repository:)

      expect { subject.perform }.to raise_error(invalid_wallet_operation_exception)
    end

    it 'raises InvalidWalletOperation if origin and destination accounts are the same' do
      sender_account = BankTransfer::Entities::Account.new(
        id: '37541a9b-ccb1-4e50-9794-b608ed0feffc'
      )
      receiver_account = sender_account
      transfer = instance_double(
        BankTransfer::Dtos::Transfer,
        account_from_id: sender_account.id,
        account_to_id: receiver_account.id
      )
      operation_with_negative_receiver_result = BankTransfer::Dtos::CreditOperation.new(
        account_from: 1000, account_to: -667
      )
      accounts_repository = class_double(BankTransfer::Repositories::AccountsRepository)
      allow(accounts_repository).to receive(:find).with(sender_account.id).and_return sender_account
      allow(accounts_repository).to receive(:find).with(receiver_account.id).and_return receiver_account
      subject = described_class.new(transfer, operation_with_negative_receiver_result,
                                    accounts_repository:)

      expect { subject.perform }.to raise_error(invalid_wallet_operation_exception)
    end
  end

  private

  def invalid_wallet_operation_exception
    BankTransfer::Services::Strategies::Steps::InvalidWalletOperation
  end
end
