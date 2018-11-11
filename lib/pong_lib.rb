# FUNCTIONS #

require_relative 'pong_errors.rb'
require 'colorize'
 
public

@cwd = Dir.pwd

@d_num_regex = /\d{4}-S-\d{2}-\d\S/
@d_rev_regex = /\[\w+\]/
@d_title_regex = /\d{4}-S-\d{2}-\d\S\s\[\w+\]\s(.+)/

@config = {:correspondence => "01 Correspondence"}

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

# Public: Returns an array of folder paths in order of most recently submitted first
#
# path - the path of the correspondence folder
#
# Examples
#
# get_submission_folders(#{cwd}/01 Correspondence)
# # => ["/mnt/c/Users/brada/Desktop/00003456/01 Correspondence/180606 As CONStrucTED", "/mnt/c/Users/brada/Desktop/00003456/01 Correspondence/180429 Construction Issue"]
#
# Returns array of folders in descending order
def get_submission_folders
  path = "#{@cwd}/#{@config[:correspondence]}"
  begin
    raise IncorrectPathError if File.directory?(path)
    return Dir[path + "/*"].select { |file| File.directory?(file) }.reverse
  rescue IncorrectPathError => e
  end
end

# Public: Returns an array of folder paths in order of most recently submitted first
#
# path - the path of the correspondence folder
#
# Examples
#
# get_submission_folders(#{cwd}/01 Correspondence)
# # => ["/mnt/c/Users/brada/Desktop/00003456/01 Correspondence/180606 As CONStrucTED", "/mnt/c/Users/brada/Desktop/00003456/01 Correspondence/180429 Construction Issue"]
#
# Returns array of folders in descending order
def get_all_drawings(submissions)
# Initialize temporary array to have Drawing objects appended
  drawings = [] 
  # Iterate through sorted array of submission folders
  submissions.each do |submission|
    # Skip to the next folder if folder is empty
    #>>> ADD EMPTY FOLDER WARNING FEEDBACK MESSAGE HERE <<<
    next if submission.empty?
    # Iterate through files in submission folder
    files = Dir["#{submission}/*.pdf"]
    files.each do |path|
      # Check that file is relevant drawing
      next if File.basename(path).is_pdf_drawing? == false
      # Extract information if ile is relevant drawing
      drawing_number = match_regex_with_basename(@d_num_regex, path, 0)
      drawing_revision = match_regex_with_basename(@d_rev_regex, path, 0)
      drawing_title = match_regex_with_basename(@d_title_regex, path, 1)
      # Create new instance of Drawing class using extracted information, and append to drawings array
      drawings << Drawing.new(drawing_number, drawing_revision, drawing_title, path)
    end
  return drawings
  end
end

# Public: Returns an array emulating a drawing list
#
# self - an array of drawing objects
#
# Examples
#
# drawings.get_unique_drawing_list
# # => [Drawing[@number="S-01-01"], Drawing[@number="S-03-02"]]
#
# Returns a drawing list
def get_unique_drawing_list(drawings_array)
return drawings_array.uniq { |file| file.number }
end

# Public: Returns an array of the drawings to be copied
#
# self - array of all drawings
#
# Examples
#
# drawings.select_drawings_to_copy
# # => ["/mnt/c/Users/brada/Desktop/00003456/01 Correspondence/180606 As CONStrucTED", "/mnt/c/Users/brada/Desktop/00003456/01 Correspondence/180429 Construction Issue"]
#
# Returns array of drawings to be copied
def select_drawings_to_copy(drawings_array)
  # Initialize temporary array to append drawings to copy
  drawings = []
  # Generate a list of unique drawing numbers
  drawing_list = drawings_array.uniq { |file| file.number }
  # Get a list of drawings already present in Current PDFs folder
  current_pdfs = get_current_pdfs
  # Iterate through all drawings
  drawing_list.each do |drawing|
    # Generate array of all drawings of the same number
    drawing_progression = drawings_array.select { |d| drawing.number == d.number }
    # Sort array of drawings by most recent first
    drawing_progression.sort_by { |d| d.revision }
    # Select most recent drawings
    drawings << drawing_progression[0]
  end
  return (drawing_list - current_pdfs)
end

# Public: Copies files to the specified folder
#
# self - file to be copied
#
# Examples
#
# Drawing.copy_to_folder("#{cwd}/05 Drawings and Technical/11 Current PDFs/")
# # => 11 Current PDFs now contains new file
#
# Returns array of drawings to be copied
def self.copy_to_folder(folder)
  FileUtils.cp(latest_drawing.path, "#{Dir.pwd}/05 Drawings and Technical/09 Current PDFs/#{File.basename(drawing_progression[0].path)}")
end

def is_pdf_drawing?
  return true if self === /^\d{4}-S-\d{2}-\d\S\s\[\w+\]\s.+$/
end

def get_current_pdfs
  pdfs = Dir.basename["#{Dir.pwd}/05 Drawings and Technical/09 Current PDFs/*.pdf"]
  p pdfs =  pdfs.select { |pdf| File.basename(pdf).is_pdf_drawing? }
end