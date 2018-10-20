# PONG PDF #

require 'fileutils'
require_relative 'lib/drawing.rb'
require_relative 'lib/pong_lib.rb'
  
cwd = Dir.pwd
proj_number = File.basename(cwd)[-4..-1].to_i

# Get list of submissions
submissions = get_submission_folders("#{cwd}/01 Correspondence/*")

# Get an array of all drawings from the submission folders
puts drawings = get_all_drawings(submissions)


#File.open("log.txt", "a") do |line|
#  line.puts "\r" + "**** Project Number: #{proj_number} ****"
#end

#File.open("log.txt", "a") do |line|
# line.puts "Drawing       Revision   Title"
#end