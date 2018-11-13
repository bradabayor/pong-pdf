class Drawing
  attr_accessor :number, :revision, :title, :path, :is_current
  @@i = 0

  def initialize(number, revision, title, path, is_current)
    @index = @@i
    @number = number
    @revision = revision
    @title = title
    @path = path
    @is_current = is_current
    @@i += 1
  end
end