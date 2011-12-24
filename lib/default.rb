# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

# Use Syck as YAML engine, because Psych has issue with ultraviolet's syntax files
require 'yaml'
YAML::ENGINE.yamler = 'syck'
