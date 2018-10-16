module PongLib
  require 'fileutils'
  
  d_num_regex = /\d{4}-S-\d{2}-\d\S/
  d_rev_regex = /\[\w+\]/
  d_title_regex = /\d{4}-S-\d{2}-\d\S\s\[\w+\]\s(.+)/

  # Public: Checks regular expression against drawing file basename
  #
  # regex - The regular expression to be checked
  # path - The path of the drawing file to be checked
  # index - The index of the regular expression matches array to return
  #
  # Examples
  #
  # match_regex_with_basename(/\[\w+\]/, usr/desktop/0123-S-01-01 [A] GF PLAN, 0)
  # # => "A"
  #
  # Returns matches of regex against specifed drawing filename
  def match_regex_with_basename(regex, path, index)
    return regex.match(File.basename(path).to_s)[index]
  end

  def get_submission_folders(path)
    return Dir["#{cwd}"].reverse
  end

  def get_all_drawings(submissions)
    all_drawings = []

    submissions.each do |submission|
      files = Dir["#{submission}/*.pdf"]
      files.each do |path|

      drawing_number = match_regex_with_basename(d_num_regex, path, 0)
      drawing_revision = match_regex_with_basename(d_rev_regex, path, 0)
      drawing_title = match_regex_with_basename(d_title_regex, path, 1)

        all_drawings << Drawing.new(drawing_number, drawing_revision, drawing_title, path)
      end
    return all_drawings
    end
  end
  
  def get_unique_drawing_list
    return all_drawings.uniq { |file| file.number }
  end
  
  def copy_drawings_to_current_pdfs
    drawings_list.each do |drawing|
      drawing_progression = all_drawings.select { |d| drawing.number == d.number }
      drawing_progression.sort_by { |d| d.revision }
      latest_drawing = drawing_progression[0]
      FileUtils.cp(latest_drawing.path, "#{cwd}/05 Drawings and Technical/09 Current PDFs/#{File.basename(drawing_progression[0].path)}")
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