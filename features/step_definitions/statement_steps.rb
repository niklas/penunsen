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

