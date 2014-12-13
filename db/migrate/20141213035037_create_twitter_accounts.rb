class CreateTwitterAccounts < ActiveRecord::Migration
  def change
    create_table :twitter_accounts do |t|
      t.string :uid
      t.string :screen_name
      t.string :profile_image_url
      t.integer :followers_count
      t.integer :friends_count
      t.integer :statuses_count
      t.references :user, index: true

      t.timestamps
    end
  end
end
