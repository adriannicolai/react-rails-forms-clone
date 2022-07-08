class UsersController < ApplicationController
    before_action :check_api_key


    def create_new_user
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            create_new_user_data = User.create_user(params)

            if create_new_user_data[:status]
                response_data[:html] = render_to_string :partial => "/forms/templates/user_list_partial", :locals => {:user => create_new_user_data[:result]}
            end

        rescue Exception => ex
            response_data[:error] = ex.message
        end

        render :json => response_data.merge!(create_new_user_data)
    end

    def update_user
        response_data = {:status => false, :result => {}, :error => nil}

        begin
            update_user_result = User.update_user(params)

            response_data.merge!(update_user_result)
        rescue Exception => ex
            response_data[:error] = ex.message
        end

        render :json => response_data
    end

    def delete_user
    end

	private
		def check_api_key
			return { :status => false, :error => "incorrect API key" } if params["api_key"] != "1212"
		end
end
