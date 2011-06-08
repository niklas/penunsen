require 'spec_helper'

describe StatementSearch do
  it "filters by after" do
    time = Date.today
    good = Factory :statement, :entered_on => time + 1.day
    bad  = Factory :statement, :entered_on => time - 1.day

    search = StatementSearch.new :after => time
    results = search.results
    results.should include(good)
    results.should_not include(bad)
  end
  it "filters by before" do
    time = Date.today
    good = Factory :statement, :entered_on => time - 1.day
    bad  = Factory :statement, :entered_on => time + 1.day

    search = StatementSearch.new :before => time
    results = search.results
    results.should include(good)
    results.should_not include(bad)
  end
  it "filters by before and after" do
    time = Date.today
    time1 = time - 1.day
    time2 = time + 1.day
    good = Factory :statement, :entered_on => time
    bad1 = Factory :statement, :entered_on => time + 2.days
    bad2 = Factory :statement, :entered_on => time - 2.days

    search = StatementSearch.new :after => time1, :before => time2
    results = search.results
    results.should include(good)
    results.should_not include(bad1)
    results.should_not include(bad2)
  end

  it "should accept a base to search on" do
    base = mock('base')
    search = StatementSearch.new :base => base

    results = search.results
    results.should == base
  end

  it "should accept dates as seconds since epoch as string" do
    time = Time.now
    search = StatementSearch.new :after => time.to_i.to_s
    search.after.should == time.to_date
  end
  it "should accept dates as seconds since epoch as integer" do
    time = Time.now
    search = StatementSearch.new :after => time.to_i
    search.after.should == time.to_date
  end
end
