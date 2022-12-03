module BankTransfer
  module Services
    module Strategies
      module Constraints
        class TransferAmountValid
          MAXIMUM_AMOUNT_IN_REAIS = 5000

          def initialize(transfer_dto)
            @transfer_dto = transfer_dto
          end

          def valid?
            if @transfer_dto.amount_to_transfer > MAXIMUM_AMOUNT_IN_REAIS || @transfer_dto.amount_to_transfer < 0
              raise('Transfer amount greater than allowed')
            end

            true
          end
        end
      end
    end
  end
end
