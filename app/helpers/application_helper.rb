module ApplicationHelper
  
  # Return a title
  def title
    base_title = "Sayri"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  # True if parms[:tab] = tabName
  def active_tab?(tabName)
    params[:tab].to_s == tabName 
  end

  # True if parms[:action] = tabName
  def active_action?(actionName)
    params[:action].to_s == actionName 
  end
end




