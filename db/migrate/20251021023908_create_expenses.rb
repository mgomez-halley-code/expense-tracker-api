class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.decimal :amount
      t.references :category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.text :note

      t.timestamps
    end
  end
end
