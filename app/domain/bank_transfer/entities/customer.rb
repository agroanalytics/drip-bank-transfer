# frozen_string_literal: true

module BankTransfer
  module Entities
    class Customer < ActiveRecord::Base
      has_one :account
      belongs_to :bank
    end
  end
end
