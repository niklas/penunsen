class Account < ActiveRecord::Base
  has_many :statements, :order => 'entered_on DESC, entered_at DESC, id DESC'

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

  def import(given)
    prepared = []
    transaction do
      given.each do |a|
        prepared << statements.build(a)
      end

      prepared.group_by(&:entered_on).each do |date, statements|
        count = statements.count
        step  = 24.hours / count

        statements.each_with_index do |statement, index|
          statement.entered_at = statement.entered_at + (0.5 + index) * step
        end
      end

      prepared.each(&:save!)
    end
  end
end
