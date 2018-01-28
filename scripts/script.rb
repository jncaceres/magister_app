require "csv"

class Entry
  COURSES = [nil, 29, 30, 31, 33, 34]

  attr_accessor :number, :rut, :paternal, :maternal, :name, :cod, :email, :section, :user

  def initialize(number, rut, paternal, maternal, name, cod, email, section)
    @number   = number
    @rut      = rut
    @paternal = cap paternal
    @maternal = cap maternal
    @name     = cap name
    @cod      = cod
    @email    = email
    @section  = section
  end

  def to_s
    "#{section} - #{name} #{paternal} #{maternal}"
  end

  def save
    unless @user = User.find_by(email: @email)
      @user = User.new(
        email:                 @email,
        first_name:            @name,
        last_name:             [@paternal, @maternal].join(" "),
        role:                  "alumno",
        password:              @rut,
        password_confirmation: @rut
      )
    end

    @course = Course.find_by(id: COURSES[@section])
    @user.courses << @course if @course

    @user.save
  end

  private
  def cap str
    str
      .split
      .map(&:mb_chars)
      .map(&:capitalize)
      .join(" ")
  end
end

entries = Array.new

(1..5).each do |i|
  file    = File
    .open("EDU0330-sem1-2018-S#{i}.csv")
    .read

  CSV.parse(file) do |row|
    if row.first.to_s.match /\d+/
      entry    = Entry.new *row, i
      entries << entry
    end
  end
end

entries.map do |entry|
  entry.save
end