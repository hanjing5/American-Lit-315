class Coupon < ActiveRecord::Base
	belongs_to :company
	
	has_many :coupon_stats
	has_many :users, :through => :coupon_stats


	has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }
	
	attr_accessible :company_id, :name, :description, :cost_per_redeem, :limit, :redeemed, :ext_coupon_id, :meta_data, :picture
	
	def redeem
		cs ||= self.coupon_stats.find_by_user_id( user.id )
		cs ||= self.coupon_stats.create( :user_id => user.id )
		cs.redeem
	end

end

# == Schema Information
#
# Table name: coupons
#
#  id                   :integer(4)      not null, primary key
#  company_id           :integer(4)
#  created_at           :datetime
#  updated_at           :datetime
#  name                 :string(255)
#  description          :text
#  limit                :integer(4)
#  redeemed             :integer(4)      default(0)
#  ext_coupon_id        :integer(4)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  picture_updated_at   :datetime
#  meta_data            :text
#  cost_per_redeem      :decimal(8, 2)   default(0.0)
#  displayed            :integer(4)      default(0)
#  click_through        :integer(4)      default(0)
#

