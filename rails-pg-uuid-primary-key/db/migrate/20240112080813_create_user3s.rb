class CreateUser3s < ActiveRecord::Migration[7.0]
  def change
    create_table :user3s do |t|
      t.string :name

      t.timestamps
    end
  end
end
