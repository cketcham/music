class PlayCount < ActiveRecord::Migration
  def self.up
    add_column :songs, :play_count, :integer, :default => 0
  end

  def self.down
    remove_column :songs, :play_count
  end
end
