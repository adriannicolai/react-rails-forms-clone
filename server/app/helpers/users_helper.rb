module UsersHelper
    def validate_new_user(new_user_params)
        validations = {
            :name =>  { :regex => /^[a-z ,.'-]+$/i, :error => "Special Characters are not allowed" },
            :email => { :regex => /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/, :error => "Invalid email address" }
        }

        new_user_params.each do |key, value|
            p key
            p value
        end
    end
end
