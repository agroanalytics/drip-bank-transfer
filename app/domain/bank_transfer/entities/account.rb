# frozen_string_literal: true

module BankTransfer
  module Entities
    class Account < ActiveRecord::Base
      belongs_to :customer
    end
  end
end
