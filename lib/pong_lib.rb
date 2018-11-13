# FUNCTIONS #

require 'fileutils'
require_relative 'pong_errors.rb'
 
public

@cwd = Dir.pwd

@d_num_regex = /\d{4}-S-\d{2}-\d\S/
@d_rev_regex = /\[\w+\]/
@d_title_regex = /\d{4}-S-\d{2}-\d\S\s\[\w+\]\s(.+)/

def match_regex_with_basename(regex, path, index)
  return regex.match(File.basename(path).to_s)[index]
end

def get_folders(path)
  begin
    raise IncorrectPathError if File.directory?(path)
    return Dir[path].select { |file| File.directory?(file) }.reverse
  rescue IncorrectPathError => e
  end
end

def get_files_from_folder(folder, type)
  if folder.empty?
  	return nil
  else
  	drawings = Dir["#{folder}/*#{type}"]
  	return drawings.select { |drawing| drawing.is_drawing?(type) }
  end
end

def create_drawing_instance(path, is_current)
	drawing_number = match_regex_with_basename(@d_num_regex, path, 0)
    drawing_revision = match_regex_with_basename(@d_rev_regex, path, 0)[1..-2]
    drawing_title = match_regex_with_basename(@d_title_regex, path, 1)
    return Drawing.new(drawing_number, drawing_revision, drawing_title, path, is_current)
end

def get_unique_drawing_list(drawings_array)
	return drawings_array.uniq { |file| file.number }
end

def copy_drawing(drawing, destination)
  FileUtils.cp(drawing, destination)
end

def move_drawing(drawing, destination)
  FileUtils.mv(drawing, destination)
end

def is_drawing?(type)
  return true if self[/\d{4}-S-\d{2}-\d\S\s\[\w+\]\s.+.#{type}/]
end

def get_current(path, type)
  pdfs = Dir[path + "/*"]
  pdfs = pdfs.select { |pdf| File.basename(pdf).is_drawing?(type) }
end