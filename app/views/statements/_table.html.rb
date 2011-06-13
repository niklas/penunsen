module Statements
  class Table < Minimal::Template
    def to_html
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

      end
    end

    # FIXME: this smells: we want to show latest on first page, so wie order
    # descending and say last to the chronological first
    def chronic
      @chronic ||= statements.except(:order).order('entered_on ASC, entered_at ASC, id ASC').all
    end

    # tries to find the balance where the given statements started
    def earliest_balance
      if earliest.present?
        earliest.balance_amount_with_sign - earliest.amount_with_sign
      else
        0
      end
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

  end
end
