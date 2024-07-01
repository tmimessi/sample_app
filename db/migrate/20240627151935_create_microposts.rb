class CreateMicroposts < ActiveRecord::Migration[7.0]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    # retrieve all the microposts associated with a given user id in reverse order of creation
    # by including both the user_id and created_at columns as an array, we arrange for Rails to create a multiple key index, which means that Active Record uses both keys at the same time
    add_index :microposts, [:user_id, :created_at]
  end
end
