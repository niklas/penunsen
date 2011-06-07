class StatementsController < InheritedResources::Base
  belongs_to :account

  def account
    parent
  end
  helper_method :account
end
