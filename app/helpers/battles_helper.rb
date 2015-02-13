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
end
