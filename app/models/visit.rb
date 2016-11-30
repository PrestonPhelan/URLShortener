class Visit < ActiveRecord::Base
  validates :visitor_id, :url_id, presence: true

  belongs_to :visitor,
    primary_key: :id,
    foreign_key: :visitor_id,
    class_name: :User

    belongs_to :url,
      primary_key: :id,
      foreign_key: :url_id,
      class_name: :ShortenedUrl

  def self.record_visit!(user, shortened_url)
    Visit.create!(:visitor_id => user, :url_id => shortened_url)
  end
end
