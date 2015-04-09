module PagesHelper
  def xp_display(user)
    if user.max_level?
      "(MAX LVL)"
    else
      "(#{number_with_delimiter user.total_xp}/#{number_with_delimiter user.xp_for_next_level})"
    end
  end

  def user_flair(user)
    flair = ""
    if user.max_level?
      flair += "<span class='fa fa-star-o' title='reached max level'></span> "
    end
    if user.complete_all_quests?
      flair += "<span class='fa fa-flag-checkered' title='completed all quests'></span> "
    end
    flair.html_safe
  end
end
