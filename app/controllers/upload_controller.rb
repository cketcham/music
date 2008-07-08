class UploadController < ApplicationController
  
  
  def index
    if not params[:upload].nil?
      create
    end
  end
  
  def create
    @file = params[:upload][:file]

    #check file type, and unzip or un tar if needed
    #should probably change how i look for the extensions?
    if(@file.original_filename.split(".").last == "zip")
      puts "unzip"
    elsif(@file.original_filename.split(".").last == "mp3")
      make_song(@file)
    end
  end
  
  def fix_tags
    @song = Song.new
    @song.mp3=params[:upload][:file]
    @song.set_info(params[:upload][:file].path)
  end
  
  def make_song(file)
    #make the song
    @song = Song.new
    @song.mp3=file
    @song.set_info(file.path)
    if not @song.save
      #should force you to fix the tags in the window
      flash[:notice] = "Fix the tags before you upload. using itunes or the like"
    end
  end
  
end
