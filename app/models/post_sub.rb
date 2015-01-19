class PostSub < ActiveRecord::Base
  validates :sub_id, :post_id, presence: true
  validates :sub_id, uniqueness: { scope: :post_id }

  belongs_to :sub, inverse_of: :post_subs
  belongs_to :post, inverse_of: :post_subs


end
