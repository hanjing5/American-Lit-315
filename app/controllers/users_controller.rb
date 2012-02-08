class UsersController < ApplicationController
  before_filter :authorize_current_user

  def show
	@toolbar_hash = {:user => 'active' }
  	@user = User.find( params[:id] )
  end

  def new
	@toolbar_hash = {:user => 'active' }
  	@user = User.new
  end

  def index
	@toolbar_hash = {:user => 'active' }
	puts @toolbar_hash
	puts @toolbar_hash[:user]
	puts "is this right?"
  	@users = User.limit(150).paginate( :page => params[:page], :per_page => 10 )
  end

end
