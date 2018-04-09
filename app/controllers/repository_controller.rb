class RepositoryController < ApplicationController
  def index
    repository = RepositoryOperation.new
    @children = [repository.get]
    
  end
end
