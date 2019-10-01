class SynthesisController < ApplicationController
  before_action :set_breadcrumbs

  def index
    puts "<====== Entranding Index ======>"
    puts params
    puts "We are in SynthesisController"
    puts "<====== Saliending Index ======>"
  end

  def index_with_edition
    puts "<====== Entranding Index With Edition ======>"
    puts params
    puts "We are in SynthesisController"
    puts "<====== Saliending Index With Edition ======>"
  end

  private

    def set_breadcrumbs
      @breadcrumbs = []
    end
end
