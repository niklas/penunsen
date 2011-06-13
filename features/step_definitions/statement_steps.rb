Then /^I should see the following statement data:$/ do |expected|
  having = expected.column_names.map {|field| "[@data-#{field}]" }.join
  fields = expected.column_names.map {|field| "data-#{field}" }
  selector = lambda do |row|
    fields.map { |field| row.attributes[field] }
  end

  found = tableish("table.statements tr#{having}", selector).reverse
  found.unshift expected.column_names
  expected.diff! table(found)
end

When /^I import the following statements into #{capture_model}:$/ do |m, table|
  account = model! m
  account.import table.hashes.map {|a| Factory.attributes_for(:statement, a)}
end

Then /^#{capture_model} should include the following statements:$/ do |m, expected|
  account = model! m
  expected.hashes.each do |row|
    account.statements.should be_exists(row)
  end
end

Then /^#{capture_model} should have exactly the following statements:$/ do |m, expected|
  account = model! m
  found = account.statements.map {|r| r.attributes.slice(*expected.column_names) }
  expected.map_column!('entered_at') { |s| Time.parse(s).utc } if expected.column_names.include?('entered_at')
  expected.map_column!('entered_on') { |s| Time.parse(s).to_date } if expected.column_names.include?('entered_on')
  %w(balance_amount amount).each do |amount_column|
    expected.map_column!(amount_column) { |s| s.to_i } if expected.column_names.include?(amount_column)
  end
  expected.map_column!('fake') { |b| b.to_s == 'true' || nil } if expected.column_names.include?('fake')
  expected.diff! table( found )
end
