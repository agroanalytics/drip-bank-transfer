module BankTransfer
  module Services
    module Strategies
      module Constraints
        class TransferAmountLowerThan5000
          def valid?
            raise('Transfer amount greater than allowed') unless @transfer_dto.amount <= 5000

            true
          end
        end
      end
    end
  end
end
