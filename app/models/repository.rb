class Repository
  attr_accessor :name, :path, :type, :child
  
  
  def initialize( name = nil, path = nil, type = nil, child = nil)
    @name = name
    @path = path
    @type = type
    @child = child
  end
end