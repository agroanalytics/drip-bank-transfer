class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.decimal :amount
      t.references :customer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
