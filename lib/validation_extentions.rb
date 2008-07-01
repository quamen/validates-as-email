module ActiveRecord
  module Validations
    module ClassMethods

      def validates_as_email(*attr_names)
        configuration = { :message => ActiveRecord::Errors.default_error_messages[:invalid], 
                          :on => :save, 
                          :with => nil,
                          :check_mx_record => true, }
          configuration.update(attr_names.extract_options!)

          validates_each(attr_names, configuration) do |record, attr_name, value|
            email = ValidatesAsEmail::EmailAddress.new(value)

            message = :message unless email.long_enough?
            message = :message unless email.valid?

            if configuration[:check_mx_record] && !message
              message = :message unless email.valid_mx_record?
            end

            record.errors.add(attr_name, configuration[message]) if message
          end
        end

      end
    end
  end