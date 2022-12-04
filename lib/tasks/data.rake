namespace :data do
  desc "Shows example data for testing endpoint"
  task :show => :environment do
    BankTransfer::Entities::Account.all.each do |acc|
      el = {
        customer_name: acc.customer.name,
        bank_name: acc.customer.bank.name,
        account_id: acc.id,
        amount: acc.amount.to_s
      }

      puts el
    end
  end
end
