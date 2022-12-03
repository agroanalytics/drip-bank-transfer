# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'
require 'rails_helper'

RSpec::Matchers.define_negated_matcher :not_change, :change

describe BankTransfer::Services::MoneyTransferService, type: :unit do
  context 'when transfering money' do
    let(:account_from_id) { 'account_from_id' }
    let(:account_to_id) { 'account_to_id' }
    let(:amount_to_transfer) { 423.99 }
    let(:accounts_repository) { class_double(BankTransfer::Repositories::AccountsRepository) }

    context 'and both sender and receiver accounts exist' do
      context 'and banks are different between each other' do
        it 'uses DifferentBankStrategy to perform transfer' do
          transfer = BankTransfer::Dtos::Transfer.new(account_from_id:, account_to_id:,
                                                      amount_to_transfer:)
          sender_customer = instance_double(BankTransfer::Entities::Customer, bank_id: 'BB-uuid')
          receiver_customer = instance_double(BankTransfer::Entities::Customer, bank_id: 'Nubank-uuid')
          account_from = instance_double(BankTransfer::Entities::Account, customer: sender_customer,
                                                                          id: account_from_id)
          account_to = instance_double(BankTransfer::Entities::Account, customer: receiver_customer, id: account_to_id)
          different_bank_strategy = instance_double(different_bank_strategy_klass, perform_transfer: true)
          allow(accounts_repository).to receive(:find).with(account_from_id).and_return(account_from)
          allow(accounts_repository).to receive(:find).with(account_to_id).and_return(account_to)
          allow(different_bank_strategy_klass).to receive(:new).with(transfer).and_return(different_bank_strategy)

          described_class.new(transfer, accounts_repository:).transfer

          expect(different_bank_strategy).to have_received(:perform_transfer)
        end
      end

      context 'and banks are the same between each other' do
        it 'uses SameBankStrategy to perform transfer' do
          transfer = BankTransfer::Dtos::Transfer.new(account_from_id:, account_to_id:,
                                                      amount_to_transfer:)
          sender_customer = instance_double(BankTransfer::Entities::Customer, bank_id: 'BB-uuid')
          receiver_customer = instance_double(BankTransfer::Entities::Customer, bank_id: 'BB-uuid')
          account_from = instance_double(BankTransfer::Entities::Account, customer: sender_customer,
                                                                          id: account_from_id)
          account_to = instance_double(BankTransfer::Entities::Account, customer: receiver_customer, id: account_to_id)
          same_bank_strategy = instance_double(same_bank_strategy_klass, perform_transfer: true)
          allow(accounts_repository).to receive(:find).with(account_from_id).and_return(account_from)
          allow(accounts_repository).to receive(:find).with(account_to_id).and_return(account_to)
          allow(same_bank_strategy_klass).to receive(:new).with(transfer).and_return(same_bank_strategy)

          described_class.new(transfer, accounts_repository:).transfer

          expect(same_bank_strategy).to have_received(:perform_transfer)
        end
      end
    end

    context 'and sender account does not exist' do
      it 'throws an InvalidOperationException' do
        transfer = BankTransfer::Dtos::Transfer.new(account_from_id:, account_to_id:,
                                                    amount_to_transfer:)
        allow(accounts_repository).to receive(:find).with(account_from_id).and_raise(ActiveRecord::RecordNotFound)

        subject = described_class.new(transfer, accounts_repository:)

        expect { subject.transfer }.to raise_error(BankTransfer::Services::InvalidOperationException)
      end
    end

    context 'and receiver account does not exist' do
      it 'throws an InvalidOperationException' do
        transfer = BankTransfer::Dtos::Transfer.new(account_from_id:, account_to_id:,
                                                    amount_to_transfer:)
        account_from = instance_double(BankTransfer::Entities::Account, id: account_from_id, customer: spy('customer'))
        allow(accounts_repository).to receive(:find).with(account_from_id).and_return(account_from)
        allow(accounts_repository).to receive(:find).with(account_to_id).and_raise(ActiveRecord::RecordNotFound)

        subject = described_class.new(transfer, accounts_repository:)

        expect { subject.transfer }.to raise_error(BankTransfer::Services::InvalidOperationException)
      end
    end
  end

  private

  def same_bank_strategy_klass
    BankTransfer::Services::Strategies::SameBankStrategy
  end

  def different_bank_strategy_klass
    BankTransfer::Services::Strategies::DifferentBankStrategy
  end
end

describe BankTransfer::Services::MoneyTransferService, type: :integration do
  context 'when transfering money' do
    context 'and banks are the same between each other' do
      context 'and sender has the required money amount' do
        it 'performs transfer operation with expected result' do
          account_from = bb_customer_with_1000_reais_on_account.account
          account_to = bb_customer_with_2_reais_on_account.account
          amount_to_transfer = 999.98
          transfer = BankTransfer::Dtos::Transfer.new(account_from_id: account_from.id, account_to_id: account_to.id,
                                                      amount_to_transfer:)

          result = described_class.new(transfer).transfer

          expect(bb_customer_with_1000_reais_on_account.account.reload.amount).to eq 0.02
          expect(bb_customer_with_2_reais_on_account.account.reload.amount).to eq 1001.98
        end
      end

      context 'and sender has less than the required money amount' do
        it 'does not perform transfer operation & raises InvalidOperationException' do
          account_from = bb_customer_with_1000_reais_on_account.account
          account_to = bb_customer_with_2_reais_on_account.account
          amount_to_transfer = 1000.01
          transfer = BankTransfer::Dtos::Transfer.new(account_from_id: account_from.id, account_to_id: account_to.id,
                                                      amount_to_transfer:)

          subject = described_class.new(transfer)

          expect { subject.transfer }
            .to raise_error(BankTransfer::Services::InvalidOperationException)
            .and not_change(account_from, :amount)
            .and not_change(account_to, :amount)
        end
      end
    end

    context 'and banks are different between each other' do
      context 'and sender has the required money amount, including taxes' do
        context 'and money amount is within the limit allowed' do
          it 'performs transfer operation with expected result' do
            account_from = bb_customer_with_1000_reais_on_account.account
            account_to = nubank_customer_with_500_reais_on_account.account
            amount_to_transfer = 990
            transfer = BankTransfer::Dtos::Transfer.new(account_from_id: account_from.id, account_to_id: account_to.id,
                                                        amount_to_transfer:)

            result = described_class.new(transfer).transfer

            expect(bb_customer_with_1000_reais_on_account.account.reload.amount).to eq 5
            expect(nubank_customer_with_500_reais_on_account.account.reload.amount).to eq 1490
          end
        end

        context 'and money amount is greater than the limit allowed' do
          it 'does not perform transfer operation & raises InvalidOperationException' do
            account_from = bb_customer_with_6000_reais_on_account.account
            account_to = nubank_customer_with_500_reais_on_account.account
            amount_to_transfer = 5000.01
            transfer = BankTransfer::Dtos::Transfer.new(account_from_id: account_from.id, account_to_id: account_to.id,
                                                        amount_to_transfer:)

            subject = described_class.new(transfer)

            expect { subject.transfer }
              .to raise_error(BankTransfer::Services::InvalidOperationException)
              .and not_change(account_from, :amount)
              .and not_change(account_to, :amount)
          end
        end
      end

      context 'and sender has less than the required money amount, including taxes' do
        it 'does not perform transfer operation & raises InvalidOperationException' do
          account_from = bb_customer_with_1000_reais_on_account.account
          account_to = nubank_customer_with_500_reais_on_account.account
          amount_to_transfer = 996
          transfer = BankTransfer::Dtos::Transfer.new(account_from_id: account_from.id, account_to_id: account_to.id,
                                                      amount_to_transfer:)

          subject = described_class.new(transfer)

          expect { subject.transfer }
            .to raise_error(BankTransfer::Services::InvalidOperationException)
            .and not_change(account_from, :amount)
            .and not_change(account_to, :amount)
        end
      end
    end
  end

  def bb_customer_with_2_reais_on_account
    @chavo ||= BankTransfer::Entities::Customer.create(
      name: 'El Chavo del Ocho',
      bank_id: bb_bank.id
    )
    @chavo_account ||= BankTransfer::Entities::Account.create(customer_id: @chavo.id, amount: 2)

    @chavo
  end

  def bb_customer_with_1000_reais_on_account
    @sasque ||= BankTransfer::Entities::Customer.create(
      name: 'Sasque Otirra',
      bank_id: bb_bank.id
    )
    @sasque_account ||= BankTransfer::Entities::Account.create(customer_id: @sasque.id, amount: 1000)

    @sasque
  end

  def bb_customer_with_6000_reais_on_account
    @sasque ||= BankTransfer::Entities::Customer.create(
      name: 'Tio Patinhas',
      bank_id: bb_bank.id
    )
    @sasque_account ||= BankTransfer::Entities::Account.create(customer_id: @sasque.id, amount: 6000)

    @sasque
  end

  def nubank_customer_with_500_reais_on_account
    @charuto ||= BankTransfer::Entities::Customer.create(
      name: 'Charuto Harumaque',
      bank_id: nubank_bank.id
    )
    @charuto_account ||= BankTransfer::Entities::Account.create(customer_id: @charuto.id, amount: 500)

    @charuto
  end

  def bb_bank
    @bb_bank ||= BankTransfer::Entities::Bank.create(name: 'Banco do Brasil')
  end

  def nubank_bank
    @nubank_bank ||= BankTransfer::Entities::Bank.create(name: 'NuBank')
  end
end
