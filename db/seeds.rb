# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

bb = BankTransfer::Entities::Bank.create(name: "Banco do Brasil")
nubank = BankTransfer::Entities::Bank.create(name: "NuBank")
itau = BankTransfer::Entities::Bank.create(name: "Itau")
chaves = BankTransfer::Entities::Customer.create(name: "Chaves", bank_id: bb.id)
seu_madruga = BankTransfer::Entities::Customer.create(name: "Seu Madruga", bank_id: bb.id)
chiquinha = BankTransfer::Entities::Customer.create(name: "Chiquinha", bank_id: bb.id)
nhonho = BankTransfer::Entities::Customer.create(name: "Nhonho", bank_id: nubank.id)
patty = BankTransfer::Entities::Customer.create(name: "Patty", bank_id: nubank.id)
godinez = BankTransfer::Entities::Customer.create(name: "Godinez", bank_id: itau.id)
chaves_account = BankTransfer::Entities::Account.create(customer_id: chaves.id, amount: 0)
seu_madruga_account = BankTransfer::Entities::Account.create(customer_id: seu_madruga.id, amount: 1000)
chiquinha_account = BankTransfer::Entities::Account.create(customer_id: chiquinha.id, amount: 50)
nhonho_account = BankTransfer::Entities::Account.create(customer_id: nhonho.id, amount: 1000000)
patty_account = BankTransfer::Entities::Account.create(customer_id: patty.id, amount: 1234.56)
godinez_account = BankTransfer::Entities::Account.create(customer_id: godinez.id, amount: 666.66)
