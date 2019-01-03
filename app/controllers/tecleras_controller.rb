class TeclerasController < ApplicationController
  def index
    @tecleras = Teclera.all
  end
end
