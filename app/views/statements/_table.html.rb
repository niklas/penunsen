module Statements
  class Table < Minimal::Template
    def to_html
      calculate_balances
      table :class => 'statements' do
        thead do
          tr do
            th "Amount"
            th "Entry date"
            th "Info"
          end
        end

        tbody do
          chronic.reverse.each do |s|
            tr :class => dom_id(s), :data => { :balance => s.balance_amount_with_sign, :entered_at => s.entered_at.to_s(:db)} do
              td amount(s), :class => "amount #{s.funds_code}"
              td s.entered_on, :class => 'entered_on'
              if s.account_holder.present?
                td s.account_holder, :class => 'name'
              else
                td s.details, :class => 'details'
              end
            end
          end
        end

        tfoot do
          tr :data => {:balance => earliest_balance, :entered_at => (minimum - 1.day).to_s(:db)}  do
            td amount(earliest_balance)
          end
          tr
          tr
        end
      end
    end

    # FIXME: this smells: we want to show latest on first page, so wie order
    # descending and say last to the chronological first
    def chronic
      @chronic ||= statements.except(:order).order('entered_on ASC, entered_at ASC, id ASC').all
    end

    # tries to find the balance where the given statements started
    def earliest_balance
      return @earliest_balance if defined?(@earliest_balance)
      to_rewind = []
      found = nil

      # find the first recorded balance_amount
      chronic.each do |s|
        to_rewind << s
        if s.balance_amount.present?
          found = s.balance_amount_with_sign
          break
        end
      end

      unless found.nil?
        # rewind back
        to_rewind.each do |s|
          found -= s.amount_with_sign
        end
      else
        if account.start_balance.present?
          found = account.start_balance_with_sign
        else
          raise("no statement with a #balance_amount found and the account has no #start_balance")
        end
      end

      @earliest_balance = found
    end

    def amount(record_or_amount)
      record_or_amount = record_or_amount.amount_with_sign if record_or_amount.respond_to?(:amount_with_sign)
      number_to_currency  0.01 * record_or_amount
    end

    def minimum
      if earliest.present?
        earliest.entered_at.yesterday
      else
        Time.now.beginning_of_month
      end
    end

    def earliest
      @earliest ||= chronic.first
    end

    private
    def calculate_balances
      return if @balances_calculated
      balance = earliest_balance
      chronic.each do |s|
        balance += s.amount_with_sign
        if s.balance_amount.present?
          raise "conflict, please catch this stuff with validations" if s.balance_amount_with_sign != balance
        else
          s.balance_amount_with_sign = balance
        end
      end
      @balances_calculated = true
    end

  end
end
