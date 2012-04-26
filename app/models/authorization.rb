class Authorization < ActiveRecord::Base
  belongs_to :user
    validates_presence_of :user_id, :uid, :provider
    validates_uniqueness_of :uid, :scope => :provider

    def self.find_from_hash(hash)
    puts "in authorization find_from"
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, user = nil)
    puts "in authorization create_from"
    user ||= User.create_from_hash(hash)
    Authorization.create(:user_id => user.id, :uid => hash['uid'], :provider => hash['provider'],:token=> hash ['credentials']['token'],:secret => hash ['credentials']['secret'])
  end
end
