class Song

  attr_accessor :name
  attr_reader :artist, :genre

  @@all = []

  def initialize(name, artist=nil, genre=nil)
    @name = name
    @artist = artist
    if artist
      artist.add_song(self) unless artist.songs.include?(self)
    end

    @genre = genre
    if genre
      genre.add_song(self) unless genre.songs.include?(self)
    end

    if genre && artist
      artist.genres << genre unless artist.genres.include?(genre)
    end
  end

  def self.all
    @@all.dup.freeze
  end

  def self.destroy_all
    @@all.clear
  end

  def save
    @@all << self
  end

  def self.create(name)
    song = self.new(name)
    song.save
    song
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self) unless artist.songs.include?(self)
  end

  def genre=(genre)
    @genre = genre
    genre.add_song(self) unless genre.songs.include?(self)
  end

  def self.find_by_name(name)
    @@all.detect {|song| song.name == name}
  end

  def self.find_or_create_by_name(name)
    self.find_by_name(name) || self.create(name)
  end

  def self.new_from_filename(filename)
    song_arr = filename.split(" - ")
    genre_name = song_arr[2].gsub!(/.mp3/, "")

    artist = Artist.find_or_create_by_name(song_arr[0])
    genre = Genre.find_or_create_by_name(genre_name)
    song = self.new(song_arr[1], artist, genre)

    return song
  end

  def self.create_from_filename(filename)
    song = self.new_from_filename(filename)
    song.save
    song
  end

end
