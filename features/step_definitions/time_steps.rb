Given /^now is (.*)$/ do |time_string|
  time = Time.parse time_string
  Timecop.travel time
end
