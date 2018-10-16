class Drawing
    attr_accessor :number, :revision, :title, :path
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