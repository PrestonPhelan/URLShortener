class CreateShortenedUrLs < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :long_url, unique: true
      t.string :short_url, unique: true
      t.integer :user_id
    end

    add_index :shortened_urls, :short_url, unique: true
  end
end
