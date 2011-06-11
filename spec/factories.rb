Factory.define :bank_account do |f|
  f.start_balance 0
  f.start_balance_sign 'credit' # optimistic
end
Factory.define :statement do |f|
  f.amount 0
  f.funds_code 'credit'
  f.sequence(:entered_on) { |i| i.days.ago.to_date }
end
