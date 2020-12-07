class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :auditor, null: false
      t.string :contact_name
      t.string :phone_number
      t.string :address
      t.string :city
      t.string :sq_ft
      t.string :utility
      t.string :other_utility
      t.string :account_number

      t.timestamps
    end
  end
end
