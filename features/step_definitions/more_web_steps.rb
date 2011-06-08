# please use only in emergencies!!11eleven, very bad practice
When /^I wait a (long|short) time$/ do |duration|
  loadavg = File.read('/proc/loadavg').split.first.to_f rescue 0.5
  seconds = case duration
            when 'long'
              23
            when 'short'
              5
            end * (1 + loadavg)
  sleep seconds
end

When /^I wait until I see "([^"]*)"$/ do |text|
  session.wait_until 5.minutes do
    page.has_content?(text)
  end
end

When /^I wait for the spinner to disappear$/ do
  session.wait_until 5.minutes do
    page.has_no_css? ".spinner"
  end
end

Then /^I should see message "([^"]*)"$/ do |message|
  Then %Q{I should see "#{message}" within ".flash"}
end

Then /^I should see the following table:$/ do |expected|
  actual = table(tableish("table tr", 'th,td'))
  expected.diff! actual
end

When /^I reload the page$/ do
  current_path = URI.parse(current_url).path
  visit current_path
end

