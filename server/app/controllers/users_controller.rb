class UsersController < ApplicationController
    before_action :check_api_key


    def create_new_user
        response_data = { :status => false, :result => {}, :error => nil }

        begin
            create_new_user_data = User.create_user(params)
        rescue Exception => ex
            response_data[:error] = ex.message
        end

        render :json => response_data.merge!(create_new_user_data)
    end

    def update_user
    end

    def delete_user
    end

	private
		def check_api_key
			return { :status => false, :error => "incorrect API key" } if params["api_key"] != "1212"
		end
end
