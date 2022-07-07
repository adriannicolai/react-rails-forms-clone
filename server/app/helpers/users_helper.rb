module UsersHelper
    def validate_new_user(new_user_params)
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            validations = {
                "name"  => { :regex => /^[a-z ,.'-]+$/i, :error => "Special Characters are not allowed" },
                "email" => { :regex => /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/, :error => "Invalid email address" }
            }

            new_user_params.each do |key, value|
                validation_key = (key === "first_name" || key === "last_name" ? "name" : key)

                next if !validations[validation_key].present?


                validation_result = (value =~ validations[validation_key][:regex])

                response_data[:result][validation_key] = validations[validation_key] if !validation_result.nil?
            end
        rescue Exception => ex
            response_data[:error] = ex.message
        end


        return response_data
    end
end
