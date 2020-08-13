class Failure < ActiveRecord::Migration[6.0]
  def change
    if ENV['FAILURE'] == '1'
      create_table :users do |t|
        t.string :name
      end
    end
  end
end
