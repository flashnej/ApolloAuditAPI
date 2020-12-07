class CreateLineItem < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.belongs_to :project, null: false

      t.string :location
      t.string :hrs_per_year
      t.string :existing_fixture
      t.string :existin_qty
      t.string :proposed_fixture
      t.string :proposed_qty
      t.string :volt
      t.string :notes

      t.timestamps
    end
  end
end