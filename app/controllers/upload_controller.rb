require 'zip/zip'
class UploadController < ApplicationController
  
  
  def index
    if not params[:upload].nil?
      create
    end
  end
  
  def create
    @file = params[:upload][:file]

    #check file type, and unzip or un tar if needed
    #TODO: untar?
    #should probably change how i look for the extensions?
    if(@file.original_filename.split(".").last == "zip")
      unzip(@file.path)
      Dir::foreach(@file.path+"d") do |file|
        if(file.split(".").last == "mp3")
          make_song(File.open(@file.path+"d/"+file))
        end
      end
      FileUtils::rm_rf(@file.path+"d")
    elsif(@file.original_filename.split(".").last == "mp3")
      make_song(@file)
    end
    redirect_to :controller => "songs"
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
  

   # source should be a zip file.
   # target should be a directory to output the contents to.
   def unzip(filename)
     unzip_dir = filename+"d"
     Zip::ZipFile::open(filename) {
     |zf| zf.each { |e|
       
     fpath = File.join(unzip_dir, e.name)
     FileUtils.mkdir_p(File.dirname(fpath))
     zf.extract(e, fpath) } }
   end
   
end
