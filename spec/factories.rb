Factory.define :bank_account do |f|
end
Factory.define :statement do |f|
  f.association :account, :factory => :bank_account
  f.amount 0
  f.funds_code 'credit'
  # arbitrary.we want to create statesments in chronological order
  f.sequence(:entered_on) { |i| (1.month.ago + i.days).to_date }
end
