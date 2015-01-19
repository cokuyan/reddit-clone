class SubDecorator < Draper::Decorator
  delegate_all

  def form_url
    object.persisted? ? h.sub_url(object) : h.subs_url
  end

  def submit_text
    object.persisted? ? "Edit Sub" : "Add Sub"
  end

  def current_is_moderator?
    h.current_user == object.moderator
  end

end
