class StatementSearch

  attr_reader :errors, :base

  Attributes = [ :before, :after ]
  
  attr_reader *Attributes

  def initialize( attrs = {} )
    attrs = {} if attrs.nil? # params[:product_search] may be nil
    attrs = attrs.symbolize_keys
    attrs.assert_valid_keys( *(Attributes + [:base, :account]) )

    @errors = ActiveModel::Errors.new(self)

    @base  = attrs.delete(:base) || Statement
    if @account = attrs.delete(:account)
      @base = @account.statements
    end
    @before = format_date parse_date(attrs.delete(:before))
    @after  = format_date parse_date(attrs.delete(:after))

    @page  = attrs.delete(:page)
    @page_size = attrs.delete(:page_size) || 10
  end

  def before_date
    parse_date(before)
  end

  def after_date
    parse_date(after)
  end

  def results
    results = base

    if before.present?
      results = results.entered_before( before_date )
    end
    if after.present?
      results = results.entered_after( after_date )
    end

    results
  end
  
  include ActiveModel::AttributeMethods
  def attributes
    {}.tap do |attrs|
      Attributes.each do |name|
        attrs[name] = send(name)
      end
    end
  end

  extend ActiveModel::Naming
  include ActiveModel::Conversion

  def persisted?
    false
  end

  def valid?
    errors.empty?
  end

  def to_s
    "#{self.class}: #{attributes.inspect}"
  end

  def first_statement
    base.default_order.last
  end

  def last_statement
    base.default_order.first
  end

  def slider_options
    {
      :min => format_date(first_statement.entered_on || Date.today.at_beginning_of_year), 
      :max => format_date(last_statement.entered_on || Date.tomorrow ) 
    }
  end

  private
    def parse_date(source)
      case source
      when Date
        source
      when Fixnum
        Time.at( source ).to_date
      when /^(\d{4}).(\d{2}).(\d{2})$/
        Date.civil *[$1, $2, $3].map(&:to_i)
      when /^\d+$/
        parse_date source.to_i
      end
    end

    def format_date(date)
      date.strftime('%F') if date.present?
    end

end
