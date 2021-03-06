# Require any additional compass plugins here.
require 'ninesixty'

http_path = "/"
project_path = "content"

css_dir = "assets/css"
sass_dir = "assets/css"
images_dir = "assets/images"
javascripts_dir = "js"

http_stylesheets_path = "/assets/css"
http_images_path = "/assets/images"

output_style = :expanded

# when using SCSS:
sass_options = { :syntax => :scss }

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed
output_style = :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
