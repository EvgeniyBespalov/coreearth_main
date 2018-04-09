REPOSITORY_NAME = 'repository'
REPOSITORY_PATH = Dir.getwd
REPOSITORY_FULL_PATH = REPOSITORY_PATH + "/" + REPOSITORY_NAME
Dir.mkdir(REPOSITORY_FULL_PATH) unless Dir.exist?(REPOSITORY_FULL_PATH)
CoreearthMain::Application.config.repository_dir = Dir.new REPOSITORY_FULL_PATH