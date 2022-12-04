class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets, id: :uuid do |t|
      t.uuid :entity_id
      t.decimal :amount

      t.timestamps
    end
  end
end
