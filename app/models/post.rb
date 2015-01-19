class Post < ActiveRecord::Base
  validates :title, :author_id, presence: true

  has_many :post_subs, dependent: :destroy, inverse_of: :post
  has_many :subs, through: :post_subs
  belongs_to :author,
    class_name: 'User',
    foreign_key: :author_id

  has_many :comments, dependent: :destroy

  def update_subs!(new_sub_ids)
    new_sub_ids.delete("")
    new_sub_ids.map(&:to_i)
    transaction do
      remove_old_subs(new_sub_ids)
      add_new_subs(new_sub_ids)
    end
  end

  def comments_by_parent_id
    comments_by_parent_id = Hash.new { |h, k| h[k] = [] }
    self.comments.each do |comment|
      comments_by_parent_id[comment.parent_comment_id] << comment
    end
    comments_by_parent_id
  end

  private

  def remove_old_subs(new_sub_ids)
    old_subs = self.subs.pluck(:id) - new_sub_ids
    old_subs.each do |old_sub|
      PostSub.find_by(sub_id: old_sub, post_id: self.id).destroy!
    end
  end

  def add_new_subs(new_sub_ids)
    new_subs = new_sub_ids - self.subs.pluck(:id)
    new_subs.each do |new_sub|
      PostSub.create!(sub_id: new_sub, post_id: self.id)
    end
  end
end
