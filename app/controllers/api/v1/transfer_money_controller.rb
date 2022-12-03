class Api::V1::TransferMoneyController < ApplicationController
  def create
    transfer_money_use_case = UseCase::BankTransfer::TransferMoney.new
    render json: format(transfer_money_use_case.transfer(transfer_money_params)), status: 201
    rescue BankTransfer::Services::InvalidOperationException => e
      render json: { error: e.message }, status: 422
    rescue StandardError => e
      render json: { error: e.message }, status: 500
    end
  end

  private

  def format(transfer_result)
    {
      account_from: transfer_result[0].reload,
      account_to: transfer_result[1].reload
    }
  end

  def transfer_money_params
    params.permit(:account_from_id, :account_to_id, :amount)
  end
end
