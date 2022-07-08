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
                    ", check_new_user_params[:result]["first_name"], check_new_user_params[:result]["last_name"], check_new_user_params[:result]["email"].downcase, encrypt(check_new_user_params[:result]["password"]) 
                    ])

                    if insert_new_user_record
                        response_data[:status] = true
                        response_data[:result] = self.get_user({:fields_to_select => "id, email, first_name, last_name", :fields_to_filter => {:email => check_new_user_params[:result]["email"] }})[:result]
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

    def self.update_user(params)
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            check_update_user_params = check_fields(["first_name", "last_name", "email", "user_id"], params)

            if check_update_user_params[:status]
                # Get the exising user to update
                user_to_update = self.get_user({:fields_to_filter => {:id => decrypt(check_update_user_params[:result]["user_id"])}})

                if user_to_update[:status]
                    # Validate the new parameters
                    validate_user_params = {
                        "first_name" => check_update_user_params[:result]["first_name"],
                        "last_name" => check_update_user_params[:result]["last_name"],
                    }
                    # Add the email address if the email is changed
                    validate_user_params["email"] = check_update_user_params[:result]["email"] if user_to_update[:result]["email"] != check_update_user_params[:result]["email"].downcase

                    validate_update_user_result = validate_new_user(validate_user_params)

                    if validate_update_user_result[:status]
                        update_user = self.update_user_record({
                            :fields_to_update => {
                                :first_name => check_update_user_params[:result]["first_name"],
                                :last_name  => check_update_user_params[:result]["last_name"],
                                :email      => params["email"]
                            },
                            :fields_to_filter => {:id => user_to_update[:result]["id"]},
                        })

                        response_data.merge!(update_user)
                    else
                        response_data.merge!(validate_update_user_result)
                    end


                else
                    response_data[:error] = user_to_update[:error]
                end
            else
                response_data.merge!({:result => check_update_user_params[:result], :error => "Missing required fields"})
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
            get_user_query = ["SELECT #{ActiveRecord::Base.sanitize_sql(params[:fields_to_select])}
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

    def self.get_users(params)
        response_data = {:status => false, :result => {}, :error => nil}
        params[:fields_to_select] ||= "*"

        begin
            select_users_query = ["
                SELECT #{ActiveRecord::Base.sanitize_sql(params[:fields_to_select])}
                FROM users #{'WHERE ' if params[:fields_to_filter].present?}
            "]

            if params[:fields_to_filter].present?
                # Add the fields to filter to the query
                params[:fields_to_filter].each_with_index do |(filter, value), index|
                    select_users_query[0] += "#{' AND' if index > 0} #{filter} = ?"
                    select_users_query << value
                end
            end

            fetched_users = query_records(select_users_query)

            if fetched_users.present?
                response_data[:status] = true
                response_data[:result] = fetched_users
            else
                response_data[:error]  = "Could not find users"
            end

        rescue Exception => ex
            response_data[:error] = ex.message
        end

        return response_data
    end

    private
        def self.update_user_record(params)
            response_data = {:status => false, :result => {}, :error => nil}

            begin
                update_user_query = ["UPDATE users SET #{params[:fields_to_update].map{|field, value| "#{field} = '#{value}'"}.join(', ')},
                updated_at = NOW() WHERE"]

                params[:fields_to_filter].each_with_index do |(field, value), index|
                    update_user_query[0] += "#{' AND' if index > 0} #{field} #{value.is_a?(Array) ? 'IN(?)' : '= ?'}"
                    update_user_query << value
                end

                response_data.merge!({:status => update_record(update_user_query).present?})
            rescue Exception => ex
                response_data[:error] = ex.message
            end

            return response_data
        end
end
