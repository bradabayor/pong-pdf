# PONG PDF

# Classes

class Drawing
    @@i = 0
  
    def initialize(number, title, path)
      @index = i
      @number = number
      @title = title
      @path = path
      i += 1
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
  
  drawings_list = []
  submissions.reverse!
  
  submissions.each do |s|
      files = Dir["#{s}/*.pdf"]
      files.each do |f|
          dn = /\d{4}-S-\d{2}-\d\S/.match(f)[0]
          drawings_list << Drawing.new(dn, "GF PLAN", "cwd/cwd/abc")
      end
  end
  
  p drawings_list