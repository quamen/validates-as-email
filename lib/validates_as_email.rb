# ValidatesAsEmail

class ValidatesAsEmail

  class EmailAddress
    require 'resolv'
    
    attr_accessor :address

    def initialize(email = '')
      self.address = email
    end

    def long_enough?
      begin
        return true if address.length > 5 # r@a.wk
      rescue
        return false
      end
    end
    
    def valid?
      begin
        @domain_name = TMail::Address.parse(address).domain
        return true
      rescue
        return false
      end
    end
    
    def valid_mx_record?
      Resolv::DNS.open do |dns|
        @mx = dns.getresources(@domain_name.to_s, Resolv::DNS::Resource::IN::MX)
      end
      !@mx.empty?
    end

  end
end