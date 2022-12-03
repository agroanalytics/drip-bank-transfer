class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers, id: :uuid do |t|
      t.string :name
      t.string :email
      t.references :bank, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
