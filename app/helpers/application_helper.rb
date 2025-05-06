module ApplicationHelper
  def peso(amount)
    number_to_currency(amount, unit: "₱", precision: 2)
  end
end
