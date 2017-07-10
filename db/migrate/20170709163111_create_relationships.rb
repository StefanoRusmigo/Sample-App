class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :followed_id
    add_index :relationships, :follower_id
    add_index :relationships, [:followed_id, :follower_id], unique:true #multiple-key index that enforces uniqueness on (follower_id, followed_id) pairs, so that a user can’t follow another user more than once

  end
end