module Statements
  class Table < Minimal::Template
    def to_html
      table :class => 'statements' do
        balance = start_balance
        thead do
          tr :data => { :balance => balance } do
            th "Amount"
            th "Entry date"
            th "Info"
          end
        end

        tbody do
          statements.each do |s|
            balance += s.amount_with_sign
            tr :class => dom_id(s), :data => { :balance => balance, :entered_at => s.entered_at.to_s(:db)} do
              td amount_tag(s.amount_with_sign), :class => s.funds_code
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
      raise("no statement with a #balance_amount found") if start.nil?

      # rewind back
      to_rewind.each do |s|
        start -= s.amount_with_sign
      end

      start
    end
  end
end
