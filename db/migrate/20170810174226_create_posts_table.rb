class CreatePostsTable < ActiveRecord::Migration[5.1]
  def change
  	create_table :posts do |t|
  		t.integer :user_id
  		t.string :comment
  	end
  end
end
