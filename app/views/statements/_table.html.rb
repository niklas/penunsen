module Statements
  class Table < Minimal::Template
    def to_html
      table :class => 'statements' do
        balance = start_balance
        thead do
          tr :data => { :balance => balance, :entered_at => start_at.to_s(:db) } do
            th "Amount"
            th "Entry date"
            th "Info"
          end
        end

        tbody do
          statements.each do |s|
            balance += s.amount_with_sign
            tr :class => dom_id(s), :data => { :balance => balance, :entered_at => s.entered_at.to_s(:db)} do
              td amount_tag(s.amount_with_sign), :class => "amount #{s.funds_code}"
              td s.entered_on, :class => 'entered_on'
              if s.account_holder.present?
                td s.account_holder, :class => 'name'
              else
                td s.details, :class => 'details'
              end
            end
          end
        end
      end
    end

    def start_balance
      to_rewind = []
      start = nil

      # find the first recorded balance_amount
      statements.each do |s|
        to_rewind << s
        if s.balance_amount.present?
          start = s.balance_amount_with_sign
          break
        end
      end

      unless start.nil?
        # rewind back
        to_rewind.each do |s|
          start -= s.amount_with_sign
        end
      else
        if account.start_balance.present?
          start = account.start_balance_with_sign
        else
          raise("no statement with a #balance_amount found and the account has no #start_balance")
        end
      end

      start
    end

    def start_at
      if first = statements.first
        first.entered_at.yesterday
      else
        Time.now.beginning_of_month
      end
    end
  end
end
