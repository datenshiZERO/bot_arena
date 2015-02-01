module HexMap
  class Utils
    def self.offset_to_cube(q, r)
      x = q - (r - (r % 2)) / 2
      z = r
      y = -x-z
      [x, y, z]
    end

    def self.cube_to_offset(x, y, z)
      q = x + (z - (z % 2)) / 2
      r = z
      [q, r]
    end

    def self.distance(a, b)
      [(a.x - b.x).abs, (a.y - b.y).abs, (a.z - b.z).abs].max
    end
  end
end
