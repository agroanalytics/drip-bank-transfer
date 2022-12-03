# frozen_string_literal: true

module BankTransfer
  module Entities
    class Customer < ActiveRecord::Base
      has_one :account
    end
  end
end
