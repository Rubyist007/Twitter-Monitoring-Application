class CreateTableJoinUserAndTrackedUsers < ActiveRecord::Migration[4.2]
  def change 
    create_join_table :tracked_users, :users, column_options: { id: false } do |t|
      t.belongs_to :tracked_user, index: true 
      t.belongs_to :user, index: true 
    end

    add_index(:tracked_users_users, [:tracked_user_id, :user_id], unique: true)
  end
end
