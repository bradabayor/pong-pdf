# PONG PDF

require 'fileutils'

# Classes

class Drawing
    attr_accessor :number, :revision, :path
    @@i = 0
  
    def initialize(number, revision, title, path)
      @index = @@i
      @number = number
      @revision = revision
      @title = title
      @path = path
      @@i += 1
    end
  end
  
# Constants

cwd = Dir.pwd
proj_number = File.basename(cwd)[4..8].to_i

correspondence = "01 Correspondence"
draw_tech = "05 Drawings and Technical"

submissions = Dir["#{cwd}/#{correspondence}/*"]

puts "Project Number: #{proj_number}"
puts "Assembling Files..."

all_drawings = []
submissions.reverse!

submissions.each do |s|
    files = Dir["#{s}/*.pdf"]
    files.each do |path|
        drawing_number = /\d{4}-S-\d{2}-\d\S/.match(File.basename(path).to_s)[0]
        drawing_revision = /\[\w+\]/.match(File.basename(path).to_s)[0]
        drawing_title = /\d{4}-S-\d{2}-\d\S\s\[\w+\]\s(.+)/.match(File.basename(path).to_s)[1]
        all_drawings << Drawing.new(drawing_number, drawing_revision, drawing_title, path)
    end
end

drawings_list = all_drawings.uniq { |file| file.number }

drawings_list.each do |drawing|
    drawing_progression = all_drawings.select { |d| drawing.number == d.number }
    drawing_progression.sort_by { |d| d.revision }
    #FileUtils.cp(drawing_progression[0].path, "#{cwd}/05 Drawings and Technical/09 Current PDFs/#{File.basename(drawing_progression[0].path)}")
    puts File.basename(drawing_progression[0].path.to_s)
end

