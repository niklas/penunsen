Factory.define :bank_account do |f|
  f.start_balance 0
  f.start_balance_sign 'credit' # optimistic
end
Factory.define :statement do |f|
  f.association :account, :factory => :bank_account
  f.amount 0
  f.funds_code 'credit'
  # arbitrary.we want to create statesments in chronological order
  f.sequence(:entered_on) { |i| (1.month.ago + i.days).to_date }
end
