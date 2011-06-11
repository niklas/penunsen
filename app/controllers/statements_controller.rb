class StatementsController < InheritedResources::Base
  respond_to :html, :js

  belongs_to :account

  def account
    parent
  end
  helper_method :account

  def collection
    search.results
  end

  def search
    @search ||= StatementSearch.new search_params.merge(:account => account).reverse_merge(search_defaults)
  end

  def search_params
    params[:statement_search] || {}
  end

  def search_defaults
    {
      :before => Date.today,
      :after => 1.month.ago.to_date
    }
  end
end
