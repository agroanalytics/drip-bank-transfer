require 'rails_helper'

describe BankTransfer::Services::Strategies::Operations::DeductFixedAmountFromSenderOperation do
  context 'when operating deduction from sender' do
    it 'deducts 5 reais from sender' do
      operation = BankTransfer::Dtos::CreditOperation.new(
        account_from: 400, account_to: 666.9
      )

      operation_result = described_class.new(operation).perform

      expect(operation_result.account_from).to eq 395
      expect(operation_result.account_to).to eq 666.9
    end
  end
end
