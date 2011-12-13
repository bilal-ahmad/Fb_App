module ApplicationHelper
  def flash_messages
    flash_messages = Array.new
    flash_messages << flash[:alert] if flash[:alert]
    flash_messages << flash[:notice] if flash[:notice]
    flash_messages << flash[:error] if flash[:error]
    messages = flash_messages.map { |msg| content_tag(:li, msg) }.join
    html_class = flash[:error].present? ? 'error_explanation': 'success_message'
    html = <<-HTML
      <ul>#{messages}</ul>
    HTML
    html_str = "<div id=#{html_class}>"+html+"</div>"
    html_str.html_safe
  end

  def error_messages(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def active_class(controller_name)
    'active' if controller.controller_path == controller_name
  end

  def format_text(text_size, text)
    text.size > (text_size - 3) ? (text.slice(0..text_size)+"...") : text
  end


end
