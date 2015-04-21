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
    if user.guest?
      flair += "<span class='fa fa-exclamation-triangle' title='guest account'></span> "
    end
    if user.max_level?
      flair += "<span class='fa fa-star-o' title='reached max level'></span> "
    end
    if user.completed_all_quests?
      flair += "<span class='fa fa-flag-checkered' title='completed all quests'></span> "
    end
    flair.html_safe
  end

  def time_elapsed(secs)
    hours = secs / 3600
    secs2 = secs % 3600
    minutes = secs2 / 60
    seconds = secs2 % 60
    "%d:%02d:%02d" % [ hours, minutes, seconds ]
  end
end
