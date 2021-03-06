require "ftools" 
require "mp3info"
class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_presence_of :artist, :on => :create, :message => "can't be blank"
  validates_presence_of :album, :on => :create, :message => "can't be blank"
  
  # run write_file after save to db
  after_save :write_file

  # run delete_file method after removal from db
  # TODO:need to delete the artist and album as well
  after_destroy :delete_file
  
  def artist_name
    self.artist.name
  end
  
  def artist_name=(name)
    a=Artist.find_by_name(name)
    if a.nil?
      a=Artist.create('name' => name)
    end
    self.artist=a
  end
  
  def album_title
    self.album.title
  end
  
  def album_title=(title)
    a=Album.find_by_title(title)
    if a.nil?
      a=Album.create('title' => title)
    end
    self.album=a
  end
  
  # setter for form file field "mp3" 
  # grabs the data and sets it to an instance variable.
  # we need this so the model is in db before file save,
  # so we can use the model id as filename.
  def mp3=(file_data)
    @file_data = file_data
  end
  
  def mp3
    "#{MP3_BASE_ADDR}/#{id}/#{id}.mp3"
  end
  
  def file_name
    "#{MP3_STORAGE_PATH}/#{id}/#{id}.mp3"
  end
  
  def info
    # read and display infos & tags
    Mp3Info.open(self.file_name)
  end
  
  def hash
    Digest::MD5.hexdigest(File.read(self.file_name))
  end
  
  # write the @file_data data content to disk,
  # using the MP3_STORAGE_PATH constant.
  # saves the file with the filename of the model id
  # together with the file original extension
  def write_file(basepath = MP3_STORAGE_PATH)
    if @file_data
      File.makedirs("#{basepath}/#{id}")
      File.open("#{basepath}/#{id}/#{id}.#{extension}", "w") { |file| file.write(@file_data.read) }
      # put calls to other logic here - resizing, conversion etc.
    end
  end 
  
  # deletes the file(s) by removing the whole dir
  def delete_file(basepath = MP3_STORAGE_PATH)
    FileUtils.rm_rf("#{basepath}/#{id}")
  end
  
  # just gets the extension of uploaded file
  def extension
    begin
      @file_data.original_filename.split(".").last
    rescue
       @file_data.path.split(".").last
    end
  end
  
  def set_info(file)
    mp3info = Mp3Info.open(file)
    self.length=mp3info.length
    self.name=mp3info.tag.title
    
    self.artist=Artist.find_by_name(mp3info.tag.artist)
    if(self.artist.nil?)
      self.artist=Artist.create('name' => mp3info.tag.artist)
    end
    
    self.album=Album.find_by_title(mp3info.tag.album)
    if(self.album.nil?) 
      self.album=Album.create('title' => mp3info.tag.album , 'year' => mp3info.tag.year, 'artist' => self.artist)
    end
  end
  
  #determines if this song is identical to another
  #using the md5 hash
  def identical?
    #Song.first.attributes.each { |v,k| Song.find(:all, :conditions => [" #{v} like ?", "%blah%"])}
    Song.find(:all, :conditions => ["name = ? or length = ?", "#{self.name}", self.length]) do |x| 
      x.hash == self.hash
    end
  end
  
end
