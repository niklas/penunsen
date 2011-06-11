Then /^I should see the following statement data:$/ do |expected|
  having = expected.column_names.map {|field| "[@data-#{field}]" }.join
  fields = expected.column_names.map {|field| "data-#{field}" }
  selector = lambda do |row|
    fields.map { |field| row.attributes[field] }
  end

  found = tableish("table.statements tr#{having}", selector)
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
  expected.map_column!('entered_at') { |s| Time.parse(s).utc }
  expected.map_column!('entered_on') { |s| Time.parse(s).to_date }
  expected.diff! table( found )
end
