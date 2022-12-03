module BankTransfer
  module Services
    module Strategies
      module Steps
        class ValidateConstraints
          def initialize(transfer, constraints = [])
            @transfer = transfer
            @constraints = constraints
          end

          def perform
            valid_constraints?
          end

          private

          def valid_constraints?
            return true if @constraints.empty?
            @constraints.map { |constraint| constraint.new(@transfer).valid? }.all?
          end
        end
      end
    end
  end
end
