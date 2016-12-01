class ShortenedUrl < ActiveRecord::Base
  validates :short_url, uniqueness: true
  validates :long_url, length: { maximum: 1024}
  validate :spam_check
  validate :nonpremium_limit

  def nonpremium_limit
    if ShortenedUrl.where(user_id: user_id).count >= 5 && !submitter.premium
      errors[:Subscription] << "not premium."
    end
  end

  def spam_check
    if ShortenedUrl.where(created_at: (1.minute.ago)..Time.now, user_id: user_id).count >= 5
      errors[:submissions] << "greater than five in the last minute."
    end
  end

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visitors,
    -> { distinct },
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
    ShortenedUrl.create(
      :long_url => long_url,
      :user_id => user,
      :short_url => ShortenedUrl.random_code)
  end

  def self.prune(n)
    fresh_urls = Visit.where(created_at: n.minutes.ago..Time.now).joins(:url).select("shortened_urls.id").distinct

    ShortenedUrl.all.each do |url|
      url.destroy unless fresh_urls.include?(url.id)
    end
  end

  def num_clicks
    visits.length
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visits.where(created_at: 10.minutes.ago..Time.now).select("visitor_id").distinct.count
  end

end
