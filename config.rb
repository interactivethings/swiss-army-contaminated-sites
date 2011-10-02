### 
# Compass
###

# Susy grids in Compass
# First: gem install compass-susy-plugin
# require 'susy'

# Change Compass configuration
compass_config do |config|
  config.environment = :development
  config.http_path = "/"
  config.images_dir       = "/source/assets/app/images"
  config.http_images_path = "/assets/app/images"
  config.output_style = :compressed
  config.relative_assets = true
end

###
# Haml
###

# CodeRay syntax highlighting in Haml
# First: gem install haml-coderay
# require 'haml-coderay'

# CoffeeScript filters in Haml
# First: gem install coffee-filter
# require 'coffee-filter'

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Use the Directory Indexes feature to tell Middleman
# to create a folder for each .html file and place the
# built template file as the index of that folder.
# activate :directory_indexes

###
# Page command
###

# Per-page layout changes:
# 
# With no layout
page "*", :layout => 'layouts/default'
# 
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
# 
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  
  def is_page?(query)
    query == data.page.slug
  end

  def nav_link(slug, title)
    if is_page?(slug)
      "<li class='active'><a href='#{slug}.html'>#{title}</a></li>"
    else
      "<li><a href='#{slug}.html'>#{title}</a></li>"
    end
  end
  
  def media_image(filename, alt = "")
    "<img src='media/images/#{filename}' alt='#{alt}' />"
  end
  
  def javascript_vendor_tag(path)
    tag(:script, :src => "assets/vendor/#{path}", :type => 'text/javascript', :content => '')
  end
  
  def stylesheet_vendor_tag(path)
    tag(:link, :href => "assets/vendor/#{path}", :type => 'text/css', :rel => 'stylesheet')
  end
  
end

# Change the CSS directory
set :css_dir, "assets/app/stylesheets"

# Change the JS directory
set :js_dir, "assets/app/javascripts"

# Change the images directory
set :images_dir, "assets/app/images"

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css
  
  # Minify Javascript on build
  # activate :minify_javascript
  
  # Enable cache buster
  # activate :cache_buster
  
  # Use relative URLs
  activate :relative_assets
  
  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
  
  # Or use a different image path
  # set :http_path, "/Content/images/"
end