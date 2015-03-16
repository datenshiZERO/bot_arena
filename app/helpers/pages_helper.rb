module PagesHelper
  def xp_display(user)
    if user.max_level?
      "MAX LVL"
    else
      "(#{number_with_delimiter user.total_xp}/#{number_with_delimiter user.xp_for_next_level})"
    end
  end
end
