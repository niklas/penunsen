module ApplicationHelper
  def format_date(date)
    date.strftime '%F'
  end
end
