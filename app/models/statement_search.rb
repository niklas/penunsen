class StatementSearch

  attr_reader :errors, :base

  Attributes = [ :before, :after ]
  
  attr_reader *Attributes

  def initialize( attrs = {} )
    attrs = {} if attrs.nil? # params[:product_search] may be nil
    attrs = attrs.symbolize_keys
    attrs.assert_valid_keys( *Attributes )

    @errors = ActiveModel::Errors.new(self)

    @base  = attrs.delete(:base) || Statement
    @before = parse_date attrs.delete(:before)
    @after  = parse_date attrs.delete(:after)

    @page  = attrs.delete(:page)
    @page_size = attrs.delete(:page_size) || 10
  end

  def results
    results = base

    if before.present?
      results = results.before( before )
    end
    if after.present?
      results = results.after( after )
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
