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
    @before = parse_date attrs.delete(:before)
    @after  = parse_date attrs.delete(:after)

    @page  = attrs.delete(:page)
    @page_size = attrs.delete(:page_size) || 10
  end

  def results
    results = base

    if before.present?
      results = results.entered_before( before )
    end
    if after.present?
      results = results.entered_after( after )
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

  private
    def parse_date(source)
      case source
      when Date
        source
      when Fixnum
        Time.at( source ).to_date
      when /^\d+$/
        parse_date source.to_i
      end
    end

end
