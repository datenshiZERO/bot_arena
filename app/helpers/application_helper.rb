module ApplicationHelper
  def build_meta_tags(description: "Incremental browser SRPG", title: nil, image: url_to_image("opengraph.png"), page_type: :website)
    set_meta_tags(:title => title,
                  :description => description,
                  :open_graph => {
                    :title => title.nil? ? "Tactics?!?" : "#{title} | Tactics?!?",
                    :description => description,
                    :type => page_type,
                    :url => url_for(:only_path => false),
                    :image => [image, { :width => 200, :height => 200 }]
                  })
  end
end
