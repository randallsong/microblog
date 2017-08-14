class User < ActiveRecord::Base
	has_one :profile
	has_many :posts
	# validates_presence_of :fname
	# validates :fname, presence: true, message: "Nope, need a First Name"
	# validates_presence_of :pwd
	# validates :pwd, presence: true, message: "Nope, need a Password"
end

class Profile < ActiveRecord::Base
	belongs_to :user
end

class Post < ActiveRecord::Base
	belongs_to :user
	# validates_presence_of :comment
	# validates :comment, length: {minimum: 1, maximum: 150}
end