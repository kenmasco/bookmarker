ENV["RACK_ENV"] = 'test' #because we need to know what database to work with

#this needs to be after ENV["RACK_ENV"] = test because the server
#needs to know what environment it's running: test or devleopment.
#The environment determines what database to use.
require './server'