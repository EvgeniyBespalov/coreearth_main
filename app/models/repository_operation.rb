class RepositoryOperation
  
  def get

    repository = Repository.new
    repository.name = REPOSITORY_NAME
    repository.path = REPOSITORY_PATH
    repository.type = :folder
    repository.child = []
    
    load_struct repository
    
    repository
  end

  def create
    
  end  
  
  def modify
  
  end
  
  def destroy

  end
  
  private
  
  def load_struct struct

    dir = struct.path + "/" + struct.name

    Dir.chdir dir
    
    Dir.entries(".").select{ |d| d != "." && d != ".." && File.directory?(d) }.each do |di|
      r = Repository.new(di, dir, :folder, [])

      struct.child << r
      load_struct r
    end
    
    Dir.entries(".").select{ |d| d != "." && d != ".." && File.file?(d) }.each do |di|
      struct.child << Repository.new(di, dir, :file, [])
    end
    
  end
end