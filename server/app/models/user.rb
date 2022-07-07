include UsersHelper
include QueryHelper

class User < ApplicationRecord

    def self.create_user(new_user_params)
        validate_new_user_result = validate_new_user(new_user_params)
    end
end
