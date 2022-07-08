class FormsController < ApplicationController
	def index
		@users = User.get_users({:fields_to_select => "*"})
	end
end
