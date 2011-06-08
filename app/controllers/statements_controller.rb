class StatementsController < InheritedResources::Base
  belongs_to :account

  def account
    parent
  end
  helper_method :account

  def collection
    search.results
  end

  def search
    @search ||= StatementSearch.new search_params.merge(:base => account.statements)
  end

  def search_params
    params[:statement_search] || {}
  end
end
