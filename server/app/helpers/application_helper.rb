module ApplicationHelper
    def check_fields(required_fields = [], params)
        response_data = {:status => false, :result => {}, :error => nil}
        incomplete_fields = []

        begin
            # Check for required fields
            required_fields.each do |required_field|
                if params[required_field].present?
                    response_data[:result][required_field] = params[required_field].is_a?(String) ? params[required_field].strip : params[required_field]
                else
                    incomplete_fields << required_field
                end
            end

            incomplete_fields.present? ? response_data[:result] = incomplete_fields : response_data[:status] = true
        rescue Exception => ex
            response_data[:error] = ex.message
        end

        return response_data
    end

    def encrypt_password(password)
        return Digest::MD5.hexdigest("password#{password}secured")
    end

    def encrypt(text)
        return Base64.urlsafe_encode64(text.to_s)
    end

    def decrypt(text)
        return Base64.urlsafe_decode64(text)
    end
end
