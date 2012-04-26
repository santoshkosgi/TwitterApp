class User < ActiveRecord::Base
  acts_as_authentic

  has_many :authorizations, :dependent => :destroy

  def self.create_from_hash(hash)
    create(:name => hash['user_info']['name'])
  end

  def self.create_from_hash(hash)
    puts "in user.rb"
    user = User.new(:name => hash['user_info']['name'])
    puts user.name
    puts user.valid?
    if user.save(:validate => false) #create the user without performing validations. This is because most of the fields are not set.
    puts "user saved in user.rb"
    else
    puts "not saved"
    end
    puts user.name
    user.reset_persistence_token! #set persistence_token else sessions will not be created
    user
  end
end
