class TmpUsersController < ApplicationController
  skip_before_filter :verify_authenticity_token # HIGH SECURITY RISK!

  def show
    @token = params[:token]
	@coupon_id = params[:coupon_id]


	render :layout => false
  end

	def success
		render :layout=>false
	end

	def failure
		render :layout=>false
	end
  def redeemed_to_soon
    @coupon_stat_id = params[:coupon_stat]
    @coupon_stat = CouponStat.find(@coupon_stat_id)
    render :layout=>false
  end
  def create
	respond_to do |format|
		# Convert post requests to the right format for standardization
		# tmp_user: {email:value, token:value ... 
		# to 
		# tmp_user: {email:value ... }, email:value, token:value ...
		if not(params[:tmp_user].nil?)
			params[:email] = params[:tmp_user][:email]
			params[:token] = params[:tmp_user][:token]
			params[:coupon_id] = params[:tmp_user][:coupon_id]
		end

		if params[:email].nil? or params[:coupon_id].nil? or params[:token].nil?
			puts 'One of the arguments is missing'
			failure "arguments missing or invalid"

		elsif Coupon.find_by_id(params[:coupon_id]).nil? or Game.find_by_token(params[:token]).nil?
			puts 'Wrong token or coupon_id'
			failure "arguments missing or invalid"
		else
			@coupon = Coupon.find_by_id(params[:coupon_id])
			@game = Game.find_by_token(params[:token])

      info = Hash["email" => params[:email], "coupon" => params[:coupon_id], "game" => @game.id]
      @user = temp_user_login(info)
			#@user = TmpUser.new(:email=>params[:email], :coupon_id => params[:coupon_id], :game_id => @game.id)

      @company = Company.find_by_id(@coupon.company_id)
      @coupon_stat = @coupon.coupon_stats.find_by_user_id(@user.id)
			@game.earnings += @coupon.cost_per_redeem
			# redeemed!
			if @user.save && !@coupon.recently_redeemed(@user.id)
				@coupon.increment!(:redeemed)
        @coupon.redeem(@user.id)
				# send email out
				@coupon[:picture_url] = picture_path_builder(root_url, @coupon)
				CouponMailer.welcome_email(@user).deliver
				CouponMailer.coupon_email(@user, @coupon).deliver
				format.html {redirect_to :action=>'success'}
				format.xml
				format.json {render :json => {"message"=>"success"}}
      elsif @coupon.recently_redeemed(@user.id)
          format.html {redirect_to :action=>'redeemed_to_soon',:coupon_stat => @coupon_stat}
				format.xml
				format.json {render :json => {"message"=>"failure"}}
      else
				#puts "Can't save?"
				#failure "unknown error"
        format.html {redirect_to :action=>'failure'}
				format.xml
				format.json {render :json => {"message"=>"failure"}}
			end
		end
	  end
		# lazy "KISS principle" method to respond to failed requests
		def failure(format, msg)
				format.html {redirect_to 'failure'}
				format.xml
				format.json {render :json => {"message"=>msg}}
		end
	end
	def picture_path_builder(home_path, coupon)
		@path = home_path + 'system/pictures/'+ coupon.id.to_s+'/medium/'
	end	

  private

  def temp_user_login(info)
        unless TmpUser.find_by_email(info["email"]).nil?
            @user = TmpUser.find_by_email(info["email"])

            return @user
          else
            @user = TmpUser.create(:email => info["email"],:coupon_id => info["coupon"], :game_id => info["game"] )
            return @user
          end


  end
end
