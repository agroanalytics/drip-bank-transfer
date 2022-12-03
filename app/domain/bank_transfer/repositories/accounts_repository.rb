# frozen_string_literal: true

module BankTransfer
  module Repositories
    class AccountsRepository
      class << self
        def find(id)
          BankTransfer::Entities::Account.find(id)
        end
      end
    end
  end
end
