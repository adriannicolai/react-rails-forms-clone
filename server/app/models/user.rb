include ApplicationHelper
include UsersHelper
include QueryHelper

class User < ApplicationRecord

    def self.create_user(new_user_params)
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            check_new_user_params = check_fields(["first_name", "last_name", "email", "password", "confirm_password"], new_user_params)

            if check_new_user_params[:status]
                validate_new_user_info = validate_new_user(new_user_params)

                if validate_new_user_info[:status]
                    insert_new_user_record = insert_record(["
                        INSERT INTO users (first_name, last_name, email, password, created_at, updated_at)
                        VALUES(?,?,?,?, NOW(), NOW())
                    ", check_new_user_params[:result]["first_name"], check_new_user_params[:result]["last_name"], check_new_user_params[:result]["email"], encrypt_password(check_new_user_params[:result]["password"]) 
                    ])

                    if insert_new_user_record
                        response_data[:status] = true
                    else
                        response_data[:error]  = "Error in creating a new user, Please try again later"
                    end

                else
                    response_data.merge!({:result => validate_new_user_info[:result], :error => "Invalid new user details"})
                end
            else
                response_data.merge!({:result => check_new_user_params[:result], :error => "Missing required fields"})
            end

        rescue Exception => ex
            response_data[:error] = ex.message
        end

        return response_data
    end

    def self.get_user(params)
        response_data = {:status => false, :result => {}, :error => nil}
        
        begin
            # Set the variables needed for fetching the user
            params[:fields_to_select] ||= "*"
            get_user_query = ["SELECT #{ActiveRecord::Base.sanitize_sql_array(params[:fields_to_select])}
            FROM users WHERE"]

            # Add the fields to filter to the query
            params[:fields_to_filter].each_with_index do |(filter, value), index|
                get_user_query[0] += "#{' AND' if index > 0} #{filter} = ?"
                get_user_query << value
            end

            user_record = query_record(get_user_query)

            if user_record.present?
                response_data[:status] = true
                response_data[:result] = user_record
            else
                response_data[:error] = "User not found"
            end

        rescue Exception => ex
            response_data[:error] = ex.message
        end

        return response_data
    end
end
