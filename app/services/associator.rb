require "csv"

module Associator
  class Student
    attr_accessor :number, :rut, :paternal, :maternal, :name, :cod, :email, :user

    def initialize(number, rut, paternal, maternal, name, cod, email)
      @number   = number
      @rut      = rut
      @paternal = cap paternal
      @maternal = cap maternal
      @name     = cap name
      @cod      = cod
      @email    = email
    end

    def save_on(course)
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

      @user.courses << course if course
      @user.save
    end

    def errors
      @user.errors
    end

    private
    def cap str
      if str != nil
        str
          .split
          .map(&:mb_chars)
          .map(&:capitalize)
          .join(" ")
      end
    end
  end

  class Associate
    attr_accessor :course, :file, :students

    def initialize(course, file)
      if course.is_a? Course then
        @course = course
      else
        @course.find_by(id: course)
      end

      @students = Array.new
      @file     = file
    end

    def call
      CSV.parse(file) do |row|
        puts "ROW"
        if row.first.to_s.match /\d+/
          student    = Student.new *row
          @students << student
          puts "SALI"
        end
      end

      self
    end

    def save
      self.call unless @students.any?

      @students.map do |student|
        student.save_on(@course)
      end.all?
    end

    def errors
      @students.map(&:errors).flatten
    end
  end
end
