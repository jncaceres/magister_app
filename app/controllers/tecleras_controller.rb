class TeclerasController < ApplicationController
before_action :set_teclera, only: [:show]
  def index
    @tecleras = Teclera.all
  end

  def show
    @bar = Gchart.bar(:size => '600x400',:stacked => false, :title => "Gráfico",:bg => 'EFEFEF',:legend => ['A', 'B', 'C', 'D'],:data => [10, 30, 22, 15], :legend_position => 'top', :axis_with_labels => [['x'],['y']], :max_value => 40, :axis_labels => [["A|B|C|D"]])
  end

  def encuesta
  end

  def new
    puts params
    puts 'NEW'
    @teclera = Teclera.new
  end

  def create
    puts 'CREATE'
    puts params
    @teclera = Teclera.new(teclera_params)
    
    respond_to do |format|
      if @teclera.save
        format.html {redirect_to @teclera}
        format.json {render :show, status: :created, location: @teclera}
      end
    end
  end

  private
    def set_teclera
      @teclera = Teclera.find(params[:id])
    end

    def teclera_params
      params.permit(:cantidad)
    end

end
