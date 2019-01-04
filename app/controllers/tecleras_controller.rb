class TeclerasController < ApplicationController
  def index
    @tecleras = Teclera.all
  end

  def show
  end

  def new
    @teclera = Teclera.new
  end
end
