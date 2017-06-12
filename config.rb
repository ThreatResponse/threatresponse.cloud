configure :development do
  activate :dotenv
  activate :livereload
  activate :blog do |blog|
    blog.prefix = "blog"
    blog.permalink = "{year}/{title}.html"
  end
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  # Calculate the years for a copyright
  def copyright_years(start_year)
    end_year = Date.today.year
    if start_year == end_year
      start_year.to_s
    else
      start_year.to_s + '-' + end_year.to_s
    end
  end

end

# Build-specific configuration
configure :build do
  activate :blog do |blog|
    blog.prefix = "blog"
    blog.permalink = "{year}/{title}.html"
  end
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
   activate :minify_javascript

  # Enable cache buster
   activate :cache_buster

  # Use relative URLs
   activate :asset_hash
  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
  activate :relative_assets

  #set :relative_links, true
  # Or use a different image path
  # set :http_path, "/Content/images/"
end
