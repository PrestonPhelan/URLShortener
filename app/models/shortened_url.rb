class ShortenedUrl < ActiveRecord::Base
  validates :short_url, uniqueness: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visitors,
    through: :visits,
    source: :visitor

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  include SecureRandom

  def self.random_code
    random_code = SecureRandom.urlsafe_base64
    raise if exists?(short_url: random_code)
    rescue
      retry
    else
      return random_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(
      :long_url => long_url,
      :user_id => user,
      :short_url => ShortenedUrl.random_code)
  end
end
