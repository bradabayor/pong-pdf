# PONG PDF

require_relative 'lib/drawing.rb'
require_relative 'lib/pong_lib.rb'
  
cwd = Dir.pwd
proj_number = File.basename(cwd)[-4..-1].to_i

#File.open("log.txt", "a") do |line|
#    line.puts "\r" + "**** Project Number: #{proj_number} ****"
#end

File.open("log.txt", "a") do |line|
    line.puts "Drawing       Revision   Title"
end