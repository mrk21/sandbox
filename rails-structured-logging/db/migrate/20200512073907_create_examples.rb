class CreateExamples < ActiveRecord::Migration[6.0]
  def change
    create_table :examples do |t|
      t.string :value
      t.timestamps
    end
  end
end
