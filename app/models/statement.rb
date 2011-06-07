class Statement < ActiveRecord::Base
  default_scope :order => 'entered_on DESC, created_at DESC'
  belongs_to :account

  def amount_with_sign
    case funds_code
    when /debit/
      amount
    when /credit/
      -amount
    else
      raise("do not know how to handle funds_code #{funds_code}")
    end
  end
end
