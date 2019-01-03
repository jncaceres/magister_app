class TeclerasController < ApplicationController
  def index
    @courses = Teclera.all
  end
end
