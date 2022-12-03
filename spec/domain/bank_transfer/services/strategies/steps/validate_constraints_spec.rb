require 'rails_helper'

describe BankTransfer::Services::Strategies::Steps::ValidateConstraints do
  context 'when validating constraints' do
    it 'returns true when there are no constraints' do
      transfer = instance_double(BankTransfer::Dtos::Transfer)
      constraints = []

      subject = described_class.new(transfer, constraints)

      expect(subject.perform).to be true
    end

    it 'returns true when all validations return true' do
      transfer = instance_double(BankTransfer::Dtos::Transfer)
      constraint_1_klass = class_spy('constraint_1_klass')
      constraint_2_klass = class_spy('constraint_2_klass')
      constraint_1 = instance_spy('constraint_1', valid?: true)
      constraint_2 = instance_spy('constraint_2', valid?: true)
      allow(constraint_1).to receive(:new).with(transfer).and_return constraint_1_klass
      allow(constraint_2).to receive(:new).with(transfer).and_return constraint_2_klass
      constraints = [constraint_1_klass, constraint_2_klass]

      subject = described_class.new(transfer, constraints)

      expect(subject.perform).to be true
    end

    it 'returns false when at least one validation returns false' do
      transfer = instance_double(BankTransfer::Dtos::Transfer)
      constraint_1_klass = class_spy('constraint_1_klass')
      constraint_2_klass = class_spy('constraint_2_klass')
      constraint_1 = instance_spy('constraint_1', valid?: false)
      constraint_2 = instance_spy('constraint_2', valid?: true)
      allow(constraint_1).to receive(:new).with(transfer).and_return constraint_1_klass
      allow(constraint_2).to receive(:new).with(transfer).and_return constraint_2_klass
      constraints = [constraint_1_klass, constraint_2_klass]

      subject = described_class.new(transfer, constraints)

      expect(subject.perform).to be true
    end
  end
end
