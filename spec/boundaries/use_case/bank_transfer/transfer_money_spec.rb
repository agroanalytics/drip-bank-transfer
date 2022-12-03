# frozen_string_literal: true

require 'rails_helper'

describe UseCase::BankTransfer::TransferMoney do
  context 'when transfering money' do
    it 'converts params received to transfer DTO and then delegates transfering to service' do
      account_from_id = 'account-from-id'
      account_to_id = 'account-to-id'
      amount_to_transfer = 400
      money_transfer_service_klass = class_double(BankTransfer::Services::MoneyTransferService)
      money_transfer_service = spy(BankTransfer::Services::MoneyTransferService)
      transfer_dto_klass = BankTransfer::Dtos::Transfer
      transfer_dto = instance_double(BankTransfer::Dtos::Transfer)
      allow(transfer_dto_klass)
        .to receive(:new)
        .with(
          account_from_id:,
          account_to_id:,
          amount_to_transfer:
        ).and_return(transfer_dto)
      allow(money_transfer_service_klass)
        .to receive(:new)
        .with(transfer_dto)
        .and_return(money_transfer_service)

      subject = described_class.new(money_transfer_service: money_transfer_service_klass)
      subject.transfer(account_from_id, account_to_id, amount_to_transfer)

      expect(money_transfer_service).to have_received(:transfer)
    end
  end
end
