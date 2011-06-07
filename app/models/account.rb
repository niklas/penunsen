class Account < ActiveRecord::Base
  has_many :statements
end
