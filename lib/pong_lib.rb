module PongLib
  cwd = Dir.pwd
  proj_number = File.basename(cwd)[-4..-1].to_i
  
  d_num_regex = /\d{4}-S-\d{2}-\d\S/
  d_rev_regex = /\[\w+\]/
  d_title_regex = /\d{4}-S-\d{2}-\d\S\s\[\w+\]\s(.+)/
  
  correspondence = "01 Correspondence"
  draw_tech = "05 Drawings and Technical"

  
  def get_all_drawings
      submissions = Dir["#{cwd}/#{correspondence}/*"]
      all_drawings = []
      submissions.reverse!
      submissions.each do |s|
          files = Dir["#{s}/*.pdf"]
          files.each do |path|
              drawing_number = d_num_regex.match(File.basename(path).to_s)[0]
              drawing_revision = d_rev_regex.match(File.basename(path).to_s)[0]
              drawing_title = d_title_regex.match(File.basename(path).to_s)[1]
              all_drawings << Drawing.new(drawing_number, drawing_revision, drawing_title, path)
          end
      end
  end
  
  def get_unique_drawing_list
      drawings_list = all_drawings.uniq { |file| file.number }
  end
  
  def copy_drawings_to_current_pdfs
      drawings_list.each do |drawing|
          drawing_progression = all_drawings.select { |d| drawing.number == d.number }
          drawing_progression.sort_by { |d| d.revision }
          latest_drawing = drawing_progression[0]
          #FileUtils.cp(latest_drawing.path, "#{cwd}/05 Drawings and Technical/09 Current PDFs/#{File.basename(drawing_progression[0].path)}")
          File.open("log.txt", "a") do |line|
              line.puts "#{latest_drawing.number}    #{latest_drawing.revision}      #{latest_drawing.title}"
          end
      end
  end
  
  def is_pdf_drawing?
      return true if !!(File.basename(self) =~ /^\d{4}-S-\d{2}-\d\S\s\[\w+\]\s.+$/)
  end
  
  def get_current_pdfs
      pdfs = Dir["#{Dir.pwd}/05 Drawings and Technical/09 Current PDFs/*.pdf"]
      pdfs.select! { |pdf| pdf.is_pdf_drawing? }
      return pdfs
  end
end