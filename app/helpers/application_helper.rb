module ApplicationHelper
  def amount_tag amount_in_cents
    number_to_currency  0.01 * amount_in_cents
  end
end
