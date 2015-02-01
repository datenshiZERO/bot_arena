class Arena < ActiveRecord::Base


  def processed_layout
    layout.gsub(/\s+/, "")
      .scan(/./)
      .each_slice(columns)
      .to_a
  end
end
