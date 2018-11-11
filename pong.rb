# PONG PDF #

require 'fileutils'
require 'colorize'
require "colorized_string"
require_relative 'lib/drawing.rb'
require_relative 'lib/pong_lib.rb'
  
# Save current directory to 'cwd' variable 
cwd = Dir.pwd
proj_number = File.basename(cwd)[-4..-1].to_i

# Get list of submissions
submissions = get_submission_folders

# Get an array of all drawings from the submission folders
#drawings = get_all_drawings(submissions)

# Creates a unique drawing list from the drawings array and selects the latest revision to copy
#to_copy = select_drawings_to_copy(drawings)

# Get a list of drawings currently present in Current PDFs


#File.open("log.txt", "a") do |line|
#  line.puts "\r" + "**** Project Number: #{proj_number} ****"
#end

#File.open("log.txt", "a") do |line|
# line.puts "Drawing       Revision   Title"
#end