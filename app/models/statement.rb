class Statement < ActiveRecord::Base
  belongs_to :account

  FundsCodes = %w(credit debit return_credit return_debit)
  validates_inclusion_of :funds_code, :in => FundsCodes

  validates_presence_of :entered_on

  scope :default_order, except(:order).order('entered_on DESC')
  scope :chronologically, order('entered_on ASC, entered_at ASC, id ASC')
  scope :fake, where(:fake => true)

  separately_signed :amount, :positive => /credit/, :negative => /debit/, :amount => :amount, :sign => :funds_code
  separately_signed :balance


  def funds_code=(new_funds_code)
    write_attribute :funds_code, new_funds_code.to_s
  end

  def entered_at
    read_attribute(:entered_at) || entered_on.to_time.utc
  end

  before_validation :default_entered_at
  def default_entered_at
    unless read_attribute(:entered_at)
      self.entered_at = entered_at
    end
  end

  def self.entered_after(date)
    where('entered_on >= ?', date)
  end

  def self.entered_before(date_or_time)
    case date_or_time
    when Date
      where('entered_on <= ?', date_or_time)
    when Time
      where('entered_at <= ?', date_or_time)
    else
      raise ArgumentError, "#{date_or_time} is neither Date nor Time"
    end
  end

  # this will call .all and so must be the last item in query chain
  def self.with_balance(start=nil)
    balance = start || 0
    [
      Statement.new(:entered_on => all.first.entered_on.yesterday),
      balance
    ] +
    all.map do |s|
      balance += s.amount_with_sign
      [s, balance]
    end
  end

  before_validation :set_balance_amount, :on => :create
  def set_balance_amount
    calculated = calculate_balance_amount
    if balance_amount_with_sign.present?
      if balance_amount_with_sign != calculated
        errors.add :balance_amount_with_sign, "is set to #{balance_amount_with_sign}, but calculated was #{calculated}"
      end
    else
      self.balance_amount_with_sign = calculated
    end
  end

  def calculate_balance_amount
    if previous = account.statements.entered_before( entered_at ).first
      previous.balance_amount_with_sign
    else
      0
    end + amount_with_sign
  end

  def start_balance
    balance_amount_with_sign - amount_with_sign
  end

  def to_s
    "#{self.class} #{entered_at} #{amount_with_sign} #{details}"
  end
end
