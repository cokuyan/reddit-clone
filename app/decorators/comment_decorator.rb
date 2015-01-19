class CommentDecorator < Draper::Decorator
  delegate_all

  def form_url
    object.persisted? ? h.comment_url(object) : h.comments_url
  end

  def submit_text
    object.persisted? ? "Edit Comment" : "Add Comment"
  end

  def current_is_author?
    h.current_user == object.author
  end

  def created_at
    helpers.content_tag :span, class: 'time' do
      object.created_at.strftime("%a %m/%d/%y")
    end
  end

end
