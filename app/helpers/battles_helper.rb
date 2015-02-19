module BattlesHelper
  def tile_class(value)
    if value == "*"
      "wall"
    elsif value == "."
      ""
    else
      "team-#{value.downcase}"
    end
  end

  def board_class(arena)
    case [arena.columns, arena.rows].max
    when 1..4
      "small"
    when 5..11
      "medium"
    else
      "large"
    end
  end
end
