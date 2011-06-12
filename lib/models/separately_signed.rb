module SeparatelySigned

  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def separately_signed name, opts = {}
      opts.reverse_merge!({
        :positive => 'credit',
        :negative => 'debit',
        # sources
        :amount   => :"#{name}_amount",
        :sign     => :"#{name}_sign"
      })

      amount = opts[:amount]
      sign   = opts[:sign]
      set_amount = :"#{amount}="
      set_sign   = :"#{sign}="


      define_method :"#{amount}_with_sign" do
        a = send(amount)
        return if a.blank?
        case send(sign)
        when opts[:positive]
          a
        when opts[:negative]
          -a
        else
          raise("do not know how to handle #{sign} '#{send(sign)}'")
        end
      end

      define_method :"#{amount}_with_sign=" do |g|
        send set_amount, g.abs
        send set_sign, g < 0 ? opts[:negative].to_s : opts[:positive].to_s
      end
    end
  end

end

ActiveRecord::Base.class_eval do
  include SeparatelySigned
end
