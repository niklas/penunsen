class Account < ActiveRecord::Base
  has_many :statements, :order => 'entered_on DESC'
end
