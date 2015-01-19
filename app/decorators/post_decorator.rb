class PostDecorator < Draper::Decorator
  delegate_all

  def form_url
    object.persisted? ? h.post_url(object) : h.posts_url
  end

  def submit_text
    object.persisted? ? "Edit Post" : "Add Post"
  end

  def current_is_author?
    h.current_user == object.author
  end

  def sub_checked(sub)
    object.subs.include?(sub) ? ' checked="checked"' : ""
  end

end
