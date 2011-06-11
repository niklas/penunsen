class Account < ActiveRecord::Base
  has_many :statements, :order => 'entered_on DESC'

  validates_inclusion_of :start_balance_sign, :in => %w(credit debit), :if => :start_balance?
  validates_numericality_of :start_balance, :allow_nil => true

  def start_balance_with_sign
    case start_balance_sign
    when 'credit'
      start_balance
    when 'debit'
      -start_balance
    else
      raise("do not know how to start_balance_sign #{start_balance_sign}")
    end
  end
end
