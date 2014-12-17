require "rails_helper"

RSpec.describe "Database", type: :database do
  describe "Twitter Accounts" do
    it "has an index on user_id" do
      expect(ActiveRecord::Migration.index_exists?(:twitter_accounts, :user_id)).to eq(true)
      # ActiveRecord::Migration.index_exists?(:users, :user_id, unique: true)
    end
  end

  describe "Relationships" do
    it "has an index on follower_id" do
      expect(ActiveRecord::Migration.index_exists?(:relationships, :follower_id)).to eq(true)
    end

    it "has an index on followed_id" do
      expect(ActiveRecord::Migration.index_exists?(:relationships, :followed_id)).to eq(true)
    end

    it "has a unique index on [follower_id, followed_id]" do
      expect(ActiveRecord::Migration.index_exists?(:relationships, [:follower_id, :followed_id], unique: true)).to eq(true)
    end
  end
end