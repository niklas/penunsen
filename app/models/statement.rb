class Statement < ActiveRecord::Base
  default_scope :order => 'entered_on DESC, created_at DESC'
  belongs_to :account

  FundsCodes = %w(credit debit return_credit return_debit)
  validates_inclusion_of :funds_code, :in => FundsCodes

  def amount_with_sign
    case funds_code
    when /credit/
      amount
    when /debit/
      -amount
    else
      raise("do not know how to handle funds_code #{funds_code}")
    end
  end

  def entered_at
    entered_on.to_time
  end

  def self.after(date)
    where('entered_on >= ?', date)
  end

  def self.before(date)
    where('entered_on <= ?', date)
  end
end
