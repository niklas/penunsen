class Account < ActiveRecord::Base
  has_many :statements, :order => 'entered_on DESC, entered_at DESC, id DESC', :inverse_of => :account

  class Import
    attr_reader :account, :given, :prepared

    # statements must be given in chronological order
    def initialize(account, given)
      @account    = account
      @given      = given
      @prepared   = []
    end

    def run!
      account.transaction do
        prepare!

        fix_balance_before!

        distribute_over_day!

        save!
      end
    end

    private
    def prepare!
      given.each do |a|
        prepared << account.statements.build(a)
      end
    end

    def distribute_over_day!
      prepared.group_by(&:entered_on).each do |date, statements|
        count = statements.count
        step  = 24.hours / count

        statements.each_with_index do |statement, index|
          statement.entered_at = statement.entered_at + (0.5 + index) * step
        end
      end
    end

    # returns the balance this import starts from
    def start_balance
      return @start_balance if defined?(@start_balance)
      to_rewind = []
      found = nil

      # find the first recorded balance_amount
      prepared.each do |s|
        to_rewind << s
        if s.balance_amount.present?
          found = s.balance_amount_with_sign
          break
        end
      end

      if found.present?
        # rewind back
        to_rewind.each do |s|
          found -= s.amount_with_sign
        end
      end

      @start_balance = found
    end

    # the statement directly before this import
    def previous
      @previous ||= account.statements.entered_before( first.entered_at ).last
    end

    # returns the balance the account currently has
    def actual_balance
      if previous.present?
        previous.balance_amount_with_sign
      else
        0
      end
    end
    def fix_balance_before!
      if start_balance.present?
        if start_balance != actual_balance
          if previous.present?
            raise "previous present, must correct it or do more magic"
          else
            account.statements.create!({
              :amount_with_sign => start_balance - actual_balance,
              :fake => true,
              :details => 'Fake',
              :entered_on => first.entered_on.yesterday,
              :entered_at => first.entered_on.to_time.utc - 5.minutes
            })
          end
        end
      end
    end

    def first
      prepared.first
    end

    def save!
      prepared.each(&:save!)
    end
  end

  def import(given)
    Import.new(self, given).run!
  end
end
