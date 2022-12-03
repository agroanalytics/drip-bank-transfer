module BankTransfer
  module Repositories
    class AccountsRepository
      class << self
        def find(id)
          BankTransfer::Account.find(id)
        end

        def find_by(*attrs)
          BankTransfer::Account.find_by(*attrs)
        end
      end
    end
  end
end
