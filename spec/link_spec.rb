require 'spec_helper'

describe Link do 
  context "Demonstration of how datamapper works" do

    #this is not a real test, it's simply a demo of how it works
    it "should be created and then retrieved from the db" do
      #in the beginning our databse is empty, so there are no links
      expect(Link.count).to eq(0)
      #this creates it in the databse, so it's stored on the disk
      Link.create(:title => "Makers Academy",
                  :url => "http://www.makersacademy.com/")
      #we ask the database how many links we have, it should be 1
      expect(Link.count).to eq(1)
      #Let's get the first and only link form the database
      link = Link.first
      #Now it has all the properties that it was saved with.
      expect(link.url).to eq("http://www.makersacademy.com/")
      expect(link.title).to eq("Makers Academy")
      #If we want to, we can destroy it
      link.destroy
      #so now we have no links
      expect(Link.count).to eq(0)
    end
  end
  
end