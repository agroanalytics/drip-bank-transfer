class Api::V1::TransferMoneyController < ApplicationController
  def create
    transfer_money_use_case = UseCase::BankTransfer::TransferMoney.new
    render json: format(transfer_money_use_case.transfer(
      transfer_money_params[:account_from_id],
      transfer_money_params[:account_to_id],
      transfer_money_params[:amount],
    )), status: 201
  rescue BankTransfer::Services::InvalidOperationException => e
    render json: { error: e.message }, status: 422
  rescue StandardError => e
    render json: { error: e.message }, status: 500
  end

  private

  def format(transfer_result)
    {
      account_from: transfer_result[0].reload,
      account_to: transfer_result[1].reload
    }
  end

  def transfer_money_params
    params
      .require(:transfer_money)
      .permit(:account_from_id, :account_to_id, :amount)
  end
end
