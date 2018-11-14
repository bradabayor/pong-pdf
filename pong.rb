# PONG PDF #

require 'colorize'
require 'colorized_string'
require_relative 'lib/drawing.rb'
require_relative 'lib/pong_lib.rb'
  
# Save current directory to 'cwd' variable 
cwd = Dir.pwd
proj_number = File.basename(cwd)[-4..-1].to_i

@config = {:correspondence => "#{cwd}/01 Correspondence/05 Structural Engineering",
		  		 :current_pdfs => "#{cwd}/02 Drawings & Technical/11 Current PDFs",
		  		 :superseeded => "#{cwd}/02 Drawings & Technical/11 Current PDFs/SS",
		}

# Get list of submission folder paths
submissions = get_folders("#{@config[:correspondence]}/*")

# Get an array of all drawings from the collected submission folders
all_drawings = []
submissions.each do |folder|
	submitted_drawings = get_files_from_folder(folder, "pdf")
	submitted_drawings.each do |drawing|
		all_drawings << create_drawing_instance(drawing, false)
	end	
end

# Creates a unique drawing list from the drawings array and selects the latest revision to copy
drawing_list = get_unique_drawing_list(all_drawings).sort_by { |drawing| drawing.number }

# Get a list of drawings currently present in Current PDFs
current = get_current(@config[:current_pdfs], "pdf")
current.map! { |drawing| create_drawing_instance(drawing, true) }.sort_by { |drawing| drawing.number }

# Iterate through drawing list
drawing_list.each do |drawing|
	current_drawing = current.select { |current_drawing| current_drawing.number == drawing.number }
	if current_drawing == []
		print "<<NEW>> ".colorize(:blue)
		puts "[-] => [#{drawing.revision}] :: #{drawing.number} - #{drawing.title}"
		sleep(0.5)
		copy_drawing(drawing.path, @config[:current_pdfs])
		#puts "Drawing Copied"
		next
	end
	current_drawing = current_drawing[0]
	current_drawing_revisions = drawing_list.select { |current_drawing| current_drawing.number == drawing.number }
	current_drawing_revisions.sort_by { |current_drawing| current_drawing.revision }

	#Check latest drawing against current drawing in Current PDFs
	#puts "#{current_drawing.title}: #{current_drawing.revision} <==> #{drawing.title}: #{drawing.revision}"
	if (current_drawing.number === drawing.number) && (current_drawing.revision === drawing.revision)
		print "<<UNC>> ".colorize(:green)
		puts "[#{current_drawing.revision}] == [#{drawing.revision}] :: #{drawing.number} - #{drawing.title}"
		sleep(0.5)
	elsif (current_drawing.number === drawing.number) && (current_drawing.revision < drawing.revision)
		print "<<SUP>> ".colorize(:red)
		puts "[#{current_drawing.revision}] => [#{drawing.revision}] :: #{drawing.number} - #{drawing.title}"
		sleep(0.5)
		copy_drawing(drawing.path, @config[:current_pdfs])
		move_drawing(current_drawing.path, @config[:superseeded])
		#puts "Drawing Copied and Superseeded"
		#sleep(1)
	end
end

sleep(3)


#File.open("log.txt", "a") do |line|
#  line.puts "\r" + "**** Project Number: #{proj_number} ****"
#end

#File.open("log.txt", "a") do |line|
# line.puts "Drawing       Revision   Title"
#end