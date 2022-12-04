# frozen_string_literal: true

module Api
  module V1
    class WalletController < ApplicationController
      def show
        render json: BankTransfer::Entities::Wallet.all.to_json, status: 200
      end
    end
  end
end
