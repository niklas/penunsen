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

  it "should provide min and max entered_on boundaries" do
    time = Date.today
    time1 = time - 10.days
    time2 = time + 10.days
    first = Factory :statement, :entered_on => time1
    last  = Factory :statement, :entered_on => time2

    search = StatementSearch.new

    search.first_statement.should == first
    search.last_statement.should == last
  end

  it "should accept a base to search on" do
    base = mock('base')
    search = StatementSearch.new :base => base

    results = search.results
    results.should == base
  end

  it "should take an account to search on" do
    statements = mock('statements')
    account    = mock('account')
    account.should_receive(:statements).and_return(statements)
    search = StatementSearch.new :account => account

    results = search.results
    results.should == statements
  end

  it "should accept dates as %F string (JS)" do
    time = Time.now
    search = StatementSearch.new :after => time.strftime('%F')
    search.after_date.should == time.to_date
  end
end
