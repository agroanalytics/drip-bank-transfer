# frozen_string_literal: true

require 'rails_helper'

describe BankTransfer::Services::Strategies::SameBankStrategy do
  context 'when applying same bank strategy to transfer money' do
    it 'performs all transfer steps with no constraints nor operations' do
      transfer = instance_double(
        BankTransfer::Dtos::Transfer,
        account_from_id: 'account-from-uuid',
        account_to_id: 'account-to-uuid'
      )
      credit_operation = instance_double(BankTransfer::Dtos::CreditOperation)
      credit_calculator_klass = class_double(
        BankTransfer::Services::Strategies::CreditCalculator
      )
      credit_calculator = instance_double(
        BankTransfer::Services::Strategies::CreditCalculator,
        calculate_total_credit: credit_operation
      )
      allow(credit_calculator_klass).to receive(:new).with(transfer, anything).and_return(credit_calculator)
      validate_constraints = instance_double(validate_constraints_klass)
      validate_wallet_operation = instance_double(validate_wallet_operation_klass)
      perform_account_transfer = instance_double(perform_account_transfer_klass)
      allow(validate_constraints_klass).to receive(:new).and_return(validate_constraints)
      allow(validate_wallet_operation_klass).to receive(:new).and_return(validate_wallet_operation)
      allow(perform_account_transfer_klass).to receive(:new).and_return(perform_account_transfer)
      allow(validate_constraints).to receive(:perform).and_return(true)
      allow(validate_wallet_operation).to receive(:perform).and_return(true)
      allow(perform_account_transfer).to receive(:perform).and_return(true)

      described_class.new(transfer, credit_calculator: credit_calculator_klass).perform_transfer

      expect(credit_calculator_klass).to have_received(:new).with(transfer, [])
      expect(validate_constraints_klass).to have_received(:new).with(transfer, [])
      expect(validate_wallet_operation_klass).to have_received(:new).with(transfer, credit_operation)
      expect(perform_account_transfer_klass).to have_received(:new).with(transfer, credit_operation)
    end
  end

  private

  def validate_constraints_klass
    BankTransfer::Services::Strategies::Steps::ValidateConstraints
  end

  def validate_wallet_operation_klass
    BankTransfer::Services::Strategies::Steps::ValidateWalletOperation
  end

  def perform_account_transfer_klass
    BankTransfer::Services::Strategies::Steps::PerformAccountTransfer
  end
end
