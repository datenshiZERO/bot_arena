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
    case arena.rows
    when 1..2
      "large"
    when 3..11
      "medium"
    else
      "large"
    end
  end
end
