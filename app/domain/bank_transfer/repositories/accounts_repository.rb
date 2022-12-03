# frozen_string_literal: true

module BankTransfer
  module Repositories
    class AccountsRepository
      class << self
        def find(id)
          BankTransfer::Entities::Account.find(id)
        end

        def find_by(*attrs)
          BankTransfer::Entities::Account.find_by(*attrs)
        end
      end
    end
  end
end
