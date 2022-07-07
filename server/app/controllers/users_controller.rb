class UsersController < ApplicationController
    before_action :check_api_key


    def create_new_user
        response_data = { :status => false, :result => {}, :error => nil }

        User.create_user(params)

        render :json => response_data
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
