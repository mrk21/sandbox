class CreateUser2s < ActiveRecord::Migration[7.0]
  def change
    create_table :user2s, id: :uuid, default: 'gen_uuid_v7()' do |t|
      t.string :name

      t.timestamps
      t.check_constraint 'is_uuid_v7(id)', name: 'id_is_uuid_v7'
    end
  end
end
