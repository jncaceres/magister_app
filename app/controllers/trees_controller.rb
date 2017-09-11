
class TreesController < ApplicationController
  include CtHabilitiesHelper

  before_action :set_course # , only: [:create, :new]
  before_action :set_tree, only: [:show, :edit, :update, :destroy]
  before_action :set_tree_edx, only: [:edx_view, :set_report_values]
  before_action :set_ef_visible
  before_action :set_breadcrumbs

  respond_to :html, :json

  @@includes = [:content, :feedbacks,
    { initial_content_question: [:content_choices] },
    { initial_ct_question: [:ct_choices, :ct_habilities] },
    { recuperative_content_question: [:content_choices] },
    { recuperative_ct_question: [:ct_choices, :ct_habilities] },
    { deeping_content_question: [:content_choices] },
    { deeping_ct_question: [:ct_choices, :ct_habilities] }
  ]

  def edx_view
    @username = params['lis_person_sourcedid']
    @showed_user = User.find(current_user.id)
    @performance = @tree.user_tree_performances.find_by(user_id: current_user.id)
    puts " "
    puts "aca muestro el performanceeeeeeeeeeeeeeeeeeeeeeeeeeeeee y sus datos son"
    puts @performance.inspect
    puts " "
    
    #puts params[:type].to_s

    if params[:content_choices]
      @content_choices = params[:content_choices]
    else
      @content_choices = nil
    end

    if params[:ct_choices]
      @ct_choices = params[:ct_choices]
    else
      @ct_choices = nil
    end

    #if params[:type].to_s != "initial" && params[:state].to_s != "not_seen"
      seconds_in = Time.now.to_i - params[:initial_time].to_i
      #puts "entreeeeeeeeeeee cuandooooooooooooooooooooooooooooooooooooo...****************************---"
    #end
    if @performance
      if !@performance.finish_tree_time.nil?
        render "viewed_tree"
        return
      end
    end
  
    if params[:type].to_s == "initial"


      if params[:state].to_s == "not_seen"

        if @performance
          if !@performance.finish_tree_time.nil? || !@performance.init_qt_time.nil? || !@performance.recuperative_qt1_time.nil? || !@performance.recuperative_qt2_time.nil? || !@performance.deeping_qt1_time.nil? || !@performance.deeping_qt2_time.nil?
            render "viewed_tree"
            return
          end
        end
      
        if @tree.user_tree_performances.where(user_id: current_user.id).blank?              
          @performance = @tree.user_tree_performances.create(user_id: current_user.id)
        end
        @performance.start_tree_time = Time.now
        render "edx_view", :locals => {:content_question => @tree.initial_content_question, :ct_question => @tree.initial_ct_question,
        :feedback_simple=> @tree.initial_simple_feedback, :feedback_complex => @tree.initial_complex_feedback,
        :type => "initial", :state => "not_seen", :feedback_quality => "none", :n => 0, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}

      elsif params[:state].to_s == "answered"



        if params[:content_choices] && params[:content_choices]
             @correct_content= true
             @correct_ct= true

             
             params[:content_choices].each_with_index.select {|element, i|
              if params[:content_choices][i]
               #puts "id: " + i.to_s + " boolean: " + params[:content_choices][i][].last
              end

              }

            @tree.initial_content_question.content_choices.each do |choice|

                
                #puts "controller_ choice id:"
                #puts choice.id
                #puts "controller: arreglo de choice id:"
                #puts "el valor es: " + params[:content_choices][choice.id.to_s]
                #puts params[:content_choices][choice.id][].last

                if params[:content_choices] && params[:content_choices][choice.id.to_s]               
                  
                  if choice.right.to_s != params[:content_choices][choice.id.to_s]
                    @correct_content = false
                    break
                  end
                end
            end

            @tree.initial_ct_question.ct_choices.each do |choice|

                if params[:ct_choices] && params[:ct_choices][choice.id.to_s]
                  if choice.right.to_s != params[:ct_choices][choice.id.to_s]
                    @correct_ct = false
                    break
                  end
                end
            end

            #puts "probandooooooooooooooooooooo------------"
            #puts "contenido: " + @correct_content.to_s
            #puts "pc:" +  @correct_ct.to_s

              if @correct_ct == true && @correct_content == true

                if @performance

                  puts "el tiempo en la pregunta inicial fue: " + seconds_in.to_s + " --------------------------------"
                  @performance.init_qt_time = seconds_in
                  @performance.init_content = 1.0
                  @performance.init_ct = 1.0

                  if @performance.content_sc.nil?
                    @performance.content_sc = 1
                  else
                    @performance.content_sc = @performance.content_sc + 1
                  end 

                  if @performance.content_n.nil?
                    @performance.content_n = 1
                  else
                    @performance.content_n = @performance.content_n.to_i + 1
                  end 
                    

                  @tree.initial_ct_question.ct_habilities.each do |hab|
                    puts hab.name.to_s
                    if hab.active
                      if hab.name.to_s == "Interpretación"
                        if @performance.interpretation_sc.nil?
                          @performance.interpretation_sc = 1
                        else
                          @performance.interpretation_sc = @performance.interpretation_sc + 1                           
                        end
                        if @performance.interpretation_n.nil?
                          @performance.interpretation_n = 1
                        else
                          @performance.interpretation_n = @performance.interpretation_n.to_i + 1
                        end                      
                      elsif hab.name.to_s == "Análisis"
                        if @performance.analysis_sc.nil?
                          @performance.analysis_sc = 1
                        else
                          @performance.analysis_sc = @performance.analysis_sc + 1                           
                        end
                        if @performance.analysis_n.nil?
                          @performance.analysis_n = 1
                        else
                          @performance.analysis_n = @performance.analysis_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Evaluación"
                        if @performance.evaluation_sc.nil?
                          @performance.evaluation_sc = 1
                        else
                          @performance.evaluation_sc = @performance.evaluation_sc + 1                          
                        end
                        if @performance.evaluation_n.nil?
                          @performance.evaluation_n = 1
                        else
                          @performance.evaluation_n = @performance.evaluation_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Inferencia"
                        if @performance.inference_sc.nil?
                          @performance.inference_sc = 1
                        else
                          @performance.inference_sc = @performance.inference_sc + 1
                        end
                        if @performance.inference_n.nil?
                          @performance.inference_n = 1
                        else
                          @performance.inference_n = @performance.inference_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Explicación"
                        if @performance.explanation_sc.nil?
                          @performance.explanation_sc = 1
                        else
                         @performance.explanation_sc = @performance.explanation_sc + 1
                        end
                        if @performance.explanation_n.nil?
                          @performance.explanation_n = 1
                        else
                          @performance.explanation_n = @performance.explanation_n.to_i + 1
                        end
                      elsif hab.name.to_s == "Autoregulación"
                        if @performance.selfregulation_sc.nil?
                          @performance.selfregulation_sc = 1
                        else
                          @performance.selfregulation_sc = @performance.selfregulation_sc + 1
                        end
                        if @performance.selfregulation_n.nil?
                          @performance.selfregulation_n = 1
                        else
                          @performance.selfregulation_n = @performance.selfregulation_n.to_i + 1
                        end 
                      end
                    end
                  end
                end
                
                render "edx_view", :locals => {:content_question => @tree.initial_content_question, :ct_question => @tree.initial_ct_question,
                :feedback_simple=> @tree.initial_simple_feedback, :feedback_complex => @tree.initial_complex_feedback,
                 :type => "initial", :state =>"answered", :feedback_quality => "none", :n => 0, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}



              elsif @correct_content == true && @correct_ct == false



                if @performance

                  puts "el tiempo en la pregunta inicial fue: " + seconds_in.to_s + " --------------------------------"
                  @performance.init_qt_time = seconds_in
                  @performance.init_content = 1.0
                  @performance.init_ct = 0.0

                  if @performance.content_sc.nil?
                    @performance.content_sc = 1
                  else
                    @performance.content_sc = @performance.content_sc + 1
                  end  
                  if @performance.content_n.nil?
                    @performance.content_n = 1
                  else
                    @performance.content_n = @performance.content_n.to_i + 1
                  end 

                  @tree.initial_ct_question.ct_habilities.each do |hab|
                    
                    puts hab.name.to_s
                    if hab.active
                      if hab.name.to_s == "Interpretación"
                        if @performance.interpretation_sc.nil?
                          @performance.interpretation_sc = 0
                        else
                          @performance.interpretation_sc = @performance.interpretation_sc
                        end
                        if @performance.interpretation_n.nil?
                          @performance.interpretation_n = 1
                        else
                          @performance.interpretation_n = @performance.interpretation_n.to_i + 1
                        end                       
                      elsif hab.name.to_s == "Análisis"
                        if @performance.analysis_sc.nil?
                          @performance.analysis_sc = 0
                        else
                          @performance.analysis_sc = @performance.analysis_sc
                        end
                        if @performance.analysis_n.nil?
                          @performance.analysis_n = 1
                        else
                          @performance.analysis_n = @performance.analysis_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Evaluación"
                        if @performance.evaluation_sc.nil?
                          @performance.evaluation_sc = 0
                        else
                          @performance.evaluation_sc = @performance.evaluation_sc
                        end
                        if @performance.evaluation_n.nil?
                          @performance.evaluation_n = 1
                        else
                          @performance.evaluation_n = @performance.evaluation_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Inferencia"
                        if @performance.inference_sc.nil?
                          @performance.inference_sc = 0
                        else
                         @performance.inference_sc = @performance.inference_sc
                        end
                        if @performance.inference_n.nil?
                          @performance.inference_n = 1
                        else
                          @performance.inference_n = @performance.inference_n.to_i + 1
                        end  
                      elsif hab.name.to_s == "Explicación"
                        if @performance.explanation_sc.nil?
                          @performance.explanation_sc = 0
                        else
                          @performance.explanation_sc = @performance.explanation_sc
                        end
                        if @performance.explanation_n.nil?
                          @performance.explanation_n = 1
                        else
                          @performance.explanation_n = @performance.explanation_n.to_i + 1
                        end
                      elsif hab.name.to_s == "Autoregulación"
                        if @performance.selfregulation_sc.nil?
                          @performance.selfregulation_sc = 0
                        else
                          @performance.selfregulation_sc = @performance.selfregulation_sc
                        end
                        if @performance.selfregulation_n.nil?
                          @performance.selfregulation_n = 1
                        else
                          @performance.selfregulation_n = @performance.selfregulation_n.to_i + 1
                        end 
                      end
                    end
                  end
                end


                render "edx_view", :locals => {:content_question => @tree.initial_content_question, :ct_question => @tree.initial_ct_question,
                :feedback_simple=> @tree.initial_simple_feedback, :feedback_complex => @tree.initial_complex_feedback,
                 :type => "initial", :state =>"answered", :feedback_quality => "simple", :n => 0, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}

              else
                if @performance

                  puts "el tiempo en la pregunta inicial fue: " + seconds_in.to_s + " --------------------------------"
                  @performance.init_qt_time = seconds_in
                  @performance.init_content = 0.0
                  if @correct_ct == true
                    @performance.init_ct = 1.0
                  else
                    @performance.init_ct = 0.0
                  end

                  if @performance.content_sc.nil?
                    @performance.content_sc = 0
                  else
                    @performance.content_sc = @performance.content_sc
                  end
                  if @performance.content_n.nil?
                    @performance.content_n = 1
                  else
                    @performance.content_n = @performance.content_n.to_i + 1
                  end  

                  @tree.initial_ct_question.ct_habilities.each do |hab|
                    if hab.active
                      
                      puts hab.name.to_s
                      if hab.name.to_s == "Interpretación"
                        if@performance.interpretation_sc.nil?
                          @performance.interpretation_sc = 0
                        else
                          @performance.interpretation_sc = @performance.interpretation_sc
                        end
                        if @performance.interpretation_n.nil?
                          @performance.interpretation_n = 1
                        else
                          @performance.interpretation_n = @performance.interpretation_n.to_i + 1
                        end                      
                      elsif hab.name.to_s == "Análisis"
                        if @performance.analysis_sc.nil?
                          @performance.analysis_sc = 0
                        else
                         @performance.analysis_sc = @performance.analysis_sc
                        end
                        if @performance.analysis_n.nil?
                          @performance.analysis_n = 1
                        else
                          @performance.analysis_n = @performance.analysis_n.to_i + 1
                        end  
                      elsif hab.name.to_s == "Evaluación"
                        if @performance.evaluation_sc.nil?
                          @performance.evaluation_sc = 0
                        else
                          @performance.evaluation_sc = @performance.evaluation_sc
                        end
                        if @performance.evaluation_n.nil?
                          @performance.evaluation_n = 1
                        else
                          @performance.evaluation_n = @performance.evaluation_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Inferencia"
                        if @performance.inference_sc.nil?
                          @performance.inference_sc = 0
                        else
                          @performance.inference_sc = @performance.inference_sc
                        end
                        if @performance.inference_n.nil?
                          @performance.inference_n = 1
                        else
                          @performance.inference_n = @performance.inference_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Explicación"
                        if @performance.explanation_sc.nil?
                          @performance.explanation_sc = 0
                        else
                          @performance.explanation_sc = @performance.explanation_sc
                        end
                        if @performance.explanation_n.nil?
                          @performance.explanation_n = 1
                        else
                          @performance.explanation_n = @performance.explanation_n.to_i + 1
                        end
                      elsif hab.name.to_s == "Autoregulación"
                        if @performance.selfregulation_sc.nil?
                          @performance.selfregulation_sc = 0
                        else
                          @performance.selfregulation_sc = @performance.selfregulation_sc
                        end
                        if @performance.selfregulation_n.nil?
                          @performance.selfregulation_n = 1
                        else
                          @performance.selfregulation_n = @performance.selfregulation_n.to_i + 1
                        end 
                      end
                    end
                  end
                end
                render "edx_view", :locals => {:content_question => @tree.initial_content_question, :ct_question => @tree.initial_ct_question,
                :feedback_simple=> @tree.initial_simple_feedback, :feedback_complex => @tree.initial_complex_feedback,
                 :type => "initial", :state => "answered", :feedback_quality => "complex", :n => 0, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}
              end

          else
            #if !@performance.init_qt_time.nil?
              #@performance.init_fb_time = seconds_in
              #puts "le doy tiempo al initial fb que es: " + seconds_in.to_s + "------------------------------ si el qt time no es nulo  "
            #end
            render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
                :feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
                :type => "deeping", :state =>"not_seen", :feedback_quality => "none", :n => 0, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}

          end    

      elsif params[:state].to_s == "feedback_seen"
          puts "le doy tiempo al initial fb que es: " + seconds_in.to_s + "------------------------------ feedbackseen  "
          @performance.init_fb_time = seconds_in
          render "edx_view", :locals => {:content_question => @tree.recuperative_content_question, :ct_question => @tree.recuperative_ct_question,
              :feedback_simple=> @tree.recuperative_simple_feedback, :feedback_complex => @tree.recuperative_complex_feedback,
              :type => "recuperative", :state => "not_seen", :feedback_quality => "none", :n => 0, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}
      end

    elsif params[:type] == "recuperative"

      if params[:state].to_s == "answered"
       
        if params[:content_choices] && params[:content_choices]
                 @correct_content= true
                 @correct_ct= true

                 @tree.recuperative_content_question.content_choices.each do |choice|

                    #puts "controllr: antes de entrar al if de content. Todo array y array del id de choice"
                    puts params[:content_choices]
                    #puts "controller_ choice id:"
                    #puts choice.id
                    #puts "controller: arreglo de choice id:"
                    #puts "el valor es: " + params[:content_choices][choice.id.to_s]
                    #puts params[:content_choices][choice.id][].last

                    if params[:content_choices] && params[:content_choices][choice.id.to_s]

                      #puts "probandooo_antes------------"
                      #puts "ID: " + choice.id.to_s + " right?: " + choice.right.to_s
                      if choice.right.to_s != params[:content_choices][choice.id.to_s]
                        #puts "entre al if"
                        @correct_content = false
                        break
                      end
                    end
                end

                @tree.recuperative_ct_question.ct_choices.each do |choice|

                    if params[:ct_choices] && params[:ct_choices][choice.id.to_s]
                      if choice.right.to_s != params[:ct_choices][choice.id.to_s]
                        @correct_ct = false
                        break
                      end
                    end
                end

                  if @correct_ct == true && @correct_content == true

                    if @performance
                      if params[:n].to_i < 1

                        puts "el tiempo en la pregunta recuperativa 1 fue: " + seconds_in.to_s + " --------------------------------"
                        @performance.recuperative_qt1_time = seconds_in
                        @performance.recuperative_content1 = 1.0
                        @performance.recuperative_ct1 = 1.0
                      else
                        puts "el tiempo en la pregunta recuperativa 2 fue: " + seconds_in.to_s + " --------------------------------"
                        @performance.recuperative_qt2_time = seconds_in
                        @performance.recuperative_content2 = 1.0
                        @performance.recuperative_ct2 = 1.0
                      end
                      

                      if @performance.content_sc.nil?
                        @performance.content_sc = 1
                        puts "le di el valor de 1 ------------------"
                      else
                        @performance.content_sc = @performance.content_sc + 1
                      end 

                      if @performance.content_n.nil?
                        @performance.content_n = 1
                      else
                        @performance.content_n = @performance.content_n.to_i + 1
                      end 
                        

                      @tree.recuperative_ct_question.ct_habilities.each do |hab|
                        puts "habilidades del recuperative ct questions------------------------"
                        puts hab.name.to_s
                        if hab.active
                          if hab.name.to_s == "Interpretación"
                            if @performance.interpretation_sc.nil?
                              @performance.interpretation_sc = 1
                            else
                              @performance.interpretation_sc = @performance.interpretation_sc + 1                           
                            end
                            if @performance.interpretation_n.nil?
                              @performance.interpretation_n = 1
                            else
                              @performance.interpretation_n = @performance.interpretation_n.to_i + 1
                            end                      
                          elsif hab.name.to_s == "Análisis"
                            if @performance.analysis_sc.nil?
                              @performance.analysis_sc = 1
                            else
                              @performance.analysis_sc = @performance.analysis_sc + 1                           
                            end
                            if @performance.analysis_n.nil?
                              @performance.analysis_n = 1
                            else
                              @performance.analysis_n = @performance.analysis_n.to_i + 1
                            end 
                          elsif hab.name.to_s == "Evaluación"
                            if @performance.evaluation_sc.nil?
                              @performance.evaluation_sc = 1
                            else
                              @performance.evaluation_sc = @performance.evaluation_sc + 1                          
                            end
                            if @performance.evaluation_n.nil?
                              @performance.evaluation_n = 1
                            else
                              @performance.evaluation_n = @performance.evaluation_n.to_i + 1
                            end 
                          elsif hab.name.to_s == "Inferencia"
                            if @performance.inference_sc.nil?
                              @performance.inference_sc = 1
                            else
                              @performance.inference_sc = @performance.inference_sc + 1
                            end
                            if @performance.inference_n.nil?
                              @performance.inference_n = 1
                            else
                              @performance.inference_n = @performance.inference_n.to_i + 1
                            end 
                          elsif hab.name.to_s == "Explicación"
                            if @performance.explanation_sc.nil?
                              @performance.explanation_sc = 1
                            else
                             @performance.explanation_sc = @performance.explanation_sc + 1
                            end
                            if @performance.explanation_n.nil?
                              @performance.explanation_n = 1
                            else
                              @performance.explanation_n = @performance.explanation_n.to_i + 1
                            end
                          elsif hab.name.to_s == "Autoregulación"
                            if @performance.selfregulation_sc.nil?
                              @performance.selfregulation_sc = 1
                            else
                              @performance.selfregulation_sc = @performance.selfregulation_sc + 1
                            end
                            if @performance.selfregulation_n.nil?
                              @performance.selfregulation_n = 1
                            else
                              @performance.selfregulation_n = @performance.selfregulation_n.to_i + 1
                            end 
                          end
                        end
                      end
                    end

                    render "edx_view", :locals => {:content_question => @tree.recuperative_content_question, :ct_question => @tree.recuperative_ct_question,
                    :feedback_simple=> @tree.recuperative_simple_feedback, :feedback_complex => @tree.recuperative_complex_feedback,
                     :type => "recuperative", :state =>"answered", :feedback_quality => "none", :n => params[:n].to_i, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}
                    
                  elsif @correct_content == true && @correct_ct == false

                    if @performance
                      if params[:n].to_i < 1
                        puts "el tiempo en la pregunta recuperativa 1 fue: " + seconds_in.to_s + " --------------------------------"
                        @performance.recuperative_qt1_time = seconds_in
                        @performance.recuperative_content1 = 1.0
                        @performance.recuperative_ct1 = 0.0
                      else
                        puts "el tiempo en la pregunta recuperativa 2 fue: " + seconds_in.to_s + " --------------------------------"
                        @performance.recuperative_qt2_time = seconds_in
                        @performance.recuperative_content2 = 1.0
                        @performance.recuperative_ct2 = 0.0
                      end
                                           
                  
                      if @performance.content_sc.nil?
                        @performance.content_sc = 1
                      else
                        @performance.content_sc = @performance.content_sc + 1
                      end  
                      if @performance.content_n.nil?
                        @performance.content_n = 1
                      else
                        @performance.content_n = @performance.content_n.to_i + 1
                      end 

                      @tree.recuperative_ct_question.ct_habilities.each do |hab|
                        
                        puts hab.name.to_s
                        if hab.active
                          if hab.name.to_s == "Interpretación"
                            if @performance.interpretation_sc.nil?
                              @performance.interpretation_sc = 0
                            else
                              @performance.interpretation_sc = @performance.interpretation_sc
                            end
                            if @performance.interpretation_n.nil?
                              @performance.interpretation_n = 1
                            else
                              @performance.interpretation_n = @performance.interpretation_n.to_i + 1
                            end                       
                          elsif hab.name.to_s == "Análisis"
                            if @performance.analysis_sc.nil?
                              @performance.analysis_sc = 0
                            else
                              @performance.analysis_sc = @performance.analysis_sc
                            end
                            if @performance.analysis_n.nil?
                              @performance.analysis_n = 1
                            else
                              @performance.analysis_n = @performance.analysis_n.to_i + 1
                            end 
                          elsif hab.name.to_s == "Evaluación"
                            if @performance.evaluation_sc.nil?
                              @performance.evaluation_sc = 0
                            else
                              @performance.evaluation_sc = @performance.evaluation_sc
                            end
                            if @performance.evaluation_n.nil?
                              @performance.evaluation_n = 1
                            else
                              @performance.evaluation_n = @performance.evaluation_n.to_i + 1
                            end 
                          elsif hab.name.to_s == "Inferencia"
                            if @performance.inference_sc.nil?
                              @performance.inference_sc = 0
                            else
                             @performance.inference_sc = @performance.inference_sc
                            end
                            if @performance.inference_n.nil?
                              @performance.inference_n = 1
                            else
                              @performance.inference_n = @performance.inference_n.to_i + 1
                            end  
                          elsif hab.name.to_s == "Explicación"
                            if @performance.explanation_sc.nil?
                              @performance.explanation_sc = 0
                            else
                              @performance.explanation_sc = @performance.explanation_sc
                            end
                            if @performance.explanation_n.nil?
                              @performance.explanation_n = 1
                            else
                              @performance.explanation_n = @performance.explanation_n.to_i + 1
                            end
                          elsif hab.name.to_s == "Autoregulación"
                            if @performance.selfregulation_sc.nil?
                              @performance.selfregulation_sc = 0
                            else
                              @performance.selfregulation_sc = @performance.selfregulation_sc
                            end
                            if @performance.selfregulation_n.nil?
                              @performance.selfregulation_n = 1
                            else
                              @performance.selfregulation_n = @performance.selfregulation_n.to_i + 1
                            end 
                          end
                        end
                      end
                    end

                    #if params[:n].to_i == 0
                    render "edx_view", :locals => {:content_question => @tree.recuperative_content_question, :ct_question => @tree.recuperative_ct_question,
                    :feedback_simple=> @tree.recuperative_simple_feedback, :feedback_complex => @tree.recuperative_complex_feedback,
                     :type => "recuperative", :state =>"answered", :feedback_quality => "simple", :n => params[:n].to_i, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}
                    #else
                     #render "edx_view", :locals => {:content_question => @tree.recuperative_content_question, :ct_question => @tree.recuperative_ct_question,
                    #:feedback_simple=> @tree.recuperative_simple_feedback, :feedback_complex => @tree.recuperative_complex_feedback,
                     #:type => "recuperative", :state =>"answered", :feedback_quality => "none", :n => params[:n].to_i, :content_choices => @content_choices, :ct_choices => @ct_choices}
                    #end

                  else

                    if @performance
                     if params[:n].to_i < 1
                        puts "el tiempo en la pregunta recuperativa 1 fue: " + seconds_in.to_s + " --------------------------------"
                        @performance.recuperative_qt1_time = seconds_in
                        @performance.recuperative_content1 = 0.0
                        if @correct_ct == true
                          @performance.recuperative_ct1 = 1.0
                        else
                          @performance.recuperative_ct1 = 0.0
                        end
                    else
                      puts "el tiempo en la pregunta recuperativa 2 fue: " + seconds_in.to_s + " --------------------------------"
                        @performance.recuperative_qt2_time = seconds_in
                        @performance.recuperative_content2 = 0.0
                        if @correct_ct == true
                          @performance.recuperative_ct2 = 1.0
                        else
                          @performance.recuperative_ct2 = 0.0
                        end
                    end
                     
                      
                      if @performance.content_sc.nil?
                        @performance.content_sc = 0
                      else
                        @performance.content_sc = @performance.content_sc
                      end
                      if @performance.content_n.nil?
                        @performance.content_n = 1
                      else
                        @performance.content_n = @performance.content_n.to_i + 1
                      end  

                      @tree.recuperative_ct_question.ct_habilities.each do |hab|
                        if hab.active
                          
                          puts hab.name.to_s
                          if hab.name.to_s == "Interpretación"
                            if@performance.interpretation_sc.nil?
                              @performance.interpretation_sc = 0
                            else
                              @performance.interpretation_sc = @performance.interpretation_sc
                            end
                            if @performance.interpretation_n.nil?
                              @performance.interpretation_n = 1
                            else
                              @performance.interpretation_n = @performance.interpretation_n.to_i + 1
                            end                      
                          elsif hab.name.to_s == "Análisis"
                            if @performance.analysis_sc.nil?
                              @performance.analysis_sc = 0
                            else
                             @performance.analysis_sc = @performance.analysis_sc
                            end
                            if @performance.analysis_n.nil?
                              @performance.analysis_n = 1
                            else
                              @performance.analysis_n = @performance.analysis_n.to_i + 1
                            end  
                          elsif hab.name.to_s == "Evaluación"
                            if @performance.evaluation_sc.nil?
                              @performance.evaluation_sc = 0
                            else
                              @performance.evaluation_sc = @performance.evaluation_sc
                            end
                            if @performance.evaluation_n.nil?
                              @performance.evaluation_n = 1
                            else
                              @performance.evaluation_n = @performance.evaluation_n.to_i + 1
                            end 
                          elsif hab.name.to_s == "Inferencia"
                            if @performance.inference_sc.nil?
                              @performance.inference_sc = 0
                            else
                              @performance.inference_sc = @performance.inference_sc
                            end
                            if @performance.inference_n.nil?
                              @performance.inference_n = 1
                            else
                              @performance.inference_n = @performance.inference_n.to_i + 1
                            end 
                          elsif hab.name.to_s == "Explicación"
                            if @performance.explanation_sc.nil?
                              @performance.explanation_sc = 0
                            else
                              @performance.explanation_sc = @performance.explanation_sc
                            end
                            if @performance.explanation_n.nil?
                              @performance.explanation_n = 1
                            else
                              @performance.explanation_n = @performance.explanation_n.to_i + 1
                            end
                          elsif hab.name.to_s == "Autoregulación"
                            if @performance.selfregulation_sc.nil?
                              @performance.selfregulation_sc = 0
                            else
                              @performance.selfregulation_sc = @performance.selfregulation_sc
                            end
                            if @performance.selfregulation_n.nil?
                              @performance.selfregulation_n = 1
                            else
                              @performance.selfregulation_n = @performance.selfregulation_n.to_i + 1
                            end 
                          end
                        end
                      end
                    end

                    #if params[:n].to_i == 0
                    render "edx_view", :locals => {:content_question => @tree.recuperative_content_question, :ct_question => @tree.recuperative_ct_question,
                    :feedback_simple=> @tree.recuperative_simple_feedback, :feedback_complex => @tree.recuperative_complex_feedback,
                     :type => "recuperative", :state =>"answered", :feedback_quality => "complex", :n => params[:n].to_i, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}
                  
                    #else
                     #render "edx_view", :locals => {:content_question => @tree.recuperative_content_question, :ct_question => @tree.recuperative_ct_question,
                    #:feedback_simple=> @tree.recuperative_simple_feedback, :feedback_complex => @tree.recuperative_complex_feedback,
                     #:type => "recuperative", :state =>"answered", :feedback_quality => "none", :n => params[:n].to_i, :content_choices => @content_choices, :ct_choices => @ct_choices}
                    #end
                  end

            else
              #if !@performance.recuperative_qt2_time.nil?
                #@performance.recuperative_fb2_time = seconds_in
                #puts "le doy tiempo al recuperative fb2 que es: " + seconds_in.to_s + " en el if tiempo recup_qt2 no es nul"

              #end
              render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
                    :feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
                    :type => "deeping", :state =>"not_seen", :feedback_quality => "none", :n => 0, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}

            end

      elsif params[:state].to_s == "feedback_seen"

        if params[:n].to_i < 2
          puts "le doy tiempo al recuperative fb1 que es: " + seconds_in.to_s + " ------------------------------ feedbackseen  "
          @performance.recuperative_fb1_time = seconds_in
          render "edx_view", :locals => {:content_question => @tree.recuperative_content_question, :ct_question => @tree.recuperative_ct_question,
              :feedback_simple=> @tree.recuperative_simple_feedback, :feedback_complex => @tree.recuperative_complex_feedback,
              :type => "recuperative", :state => "not_seen", :feedback_quality => "none", :n => params[:n].to_i, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}
        else
          puts "le doy tiempo al recuperative fb2 que es: " + seconds_in.to_s + " ------------------------------ feedbackseen  "
          @performance.recuperative_fb2_time = seconds_in
          render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
              :feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
              :type => "deeping", :state =>"not_seen", :feedback_quality => "none", :n => 0, :content_choices => @content_choices, :ct_choices => @ct_choices, :initial_time => Time.now.to_i}
        end

      end


    elsif params[:type].to_s == "deeping"

      if params[:state].to_s == "answered"

        if params[:content_choices] && params[:ct_choices]
             @correct_content = true
             @correct_ct = true

             @tree.deeping_content_question.content_choices.each do |choice|

                puts "controllr: antes de entrar al if de content. Todo array y array del id de choice"
                puts params[:content_choices]
                #puts "controller_ choice id:"
                #puts choice.id
                #puts "controller: arreglo de choice id:"
                #puts "el valor es: " + params[:content_choices][choice.id.to_s]
                #puts params[:content_choices][choice.id][].last

                if params[:content_choices] && params[:content_choices][choice.id.to_s]

                  puts "probandooo_antes------------"
                  puts "ID: " + choice.id.to_s + " right?: " + choice.right.to_s
                  if choice.right.to_s != params[:content_choices][choice.id.to_s]
                    puts "entre al if"
                    @correct_content = false
                    break
                  end
                end
            end

            @tree.deeping_ct_question.ct_choices.each do |choice|

                if params[:ct_choices] && params[:ct_choices][choice.id.to_s]
                  if choice.right.to_s != params[:ct_choices][choice.id.to_s]
                    @correct_ct = false
                    break
                  end
                end
            end

              if @correct_ct == true && @correct_content == true

                if @performance
                  if params[:n].to_i < 1
                    puts "el tiempo en la pregunta deeping 1 fue: " + seconds_in.to_s + " --------------------------------"
                    @performance.deeping_qt1_time = seconds_in
                    @performance.deeping_content1 = 1.0                  
                    @performance.deeping_ct1 = 1.0
                  else
                    puts "el tiempo en la pregunta deeping 2 fue: " + seconds_in.to_s + " --------------------------------"
                    @performance.deeping_qt2_time = seconds_in
                    @performance.deeping_content2 = 1.0                  
                    @performance.deeping_ct2 = 1.0
                  end                  
                  
                  if @performance.content_sc.nil?
                    @performance.content_sc = 1
                    
                  else
                    @performance.content_sc = @performance.content_sc + 1
                  end 

                  if @performance.content_n.nil?
                    @performance.content_n = 1
                  else
                    @performance.content_n = @performance.content_n.to_i + 1
                  end 
                    

                  @tree.deeping_ct_question.ct_habilities.each do |hab|
                    
                    puts hab.name.to_s
                    if hab.active
                      if hab.name.to_s == "Interpretación"
                        if @performance.interpretation_sc.nil?
                          @performance.interpretation_sc = 1
                        else
                          @performance.interpretation_sc = @performance.interpretation_sc + 1                           
                        end
                        if @performance.interpretation_n.nil?
                          @performance.interpretation_n = 1
                        else
                          @performance.interpretation_n = @performance.interpretation_n.to_i + 1
                        end                      
                      elsif hab.name.to_s == "Análisis"
                        if @performance.analysis_sc.nil?
                          @performance.analysis_sc = 1
                        else
                          @performance.analysis_sc = @performance.analysis_sc + 1                           
                        end
                        if @performance.analysis_n.nil?
                          @performance.analysis_n = 1
                        else
                          @performance.analysis_n = @performance.analysis_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Evaluación"
                        if @performance.evaluation_sc.nil?
                          @performance.evaluation_sc = 1
                        else
                          @performance.evaluation_sc = @performance.evaluation_sc + 1                          
                        end
                        if @performance.evaluation_n.nil?
                          @performance.evaluation_n = 1
                        else
                          @performance.evaluation_n = @performance.evaluation_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Inferencia"
                        if @performance.inference_sc.nil?
                          @performance.inference_sc = 1
                        else
                          @performance.inference_sc = @performance.inference_sc + 1
                        end
                        if @performance.inference_n.nil?
                          @performance.inference_n = 1
                        else
                          @performance.inference_n = @performance.inference_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Explicación"
                        if @performance.explanation_sc.nil?
                          @performance.explanation_sc = 1
                        else
                         @performance.explanation_sc = @performance.explanation_sc + 1
                        end
                        if @performance.explanation_n.nil?
                          @performance.explanation_n = 1
                        else
                          @performance.explanation_n = @performance.explanation_n.to_i + 1
                        end
                      elsif hab.name.to_s == "Autoregulación"
                        if @performance.selfregulation_sc.nil?
                          @performance.selfregulation_sc = 1
                        else
                          @performance.selfregulation_sc = @performance.selfregulation_sc + 1
                        end
                        if @performance.selfregulation_n.nil?
                          @performance.selfregulation_n = 1
                        else
                          @performance.selfregulation_n = @performance.selfregulation_n.to_i + 1
                        end 
                      end
                    end
                  end
                end
                
                render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
                :feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
                 :type => "deeping", :state =>"answered", :feedback_quality => "none", :n => params[:n].to_i, :content_choices => params[:content_choices], :ct_choices => params[:ct_choices], :initial_time => Time.now.to_i}

                
              elsif @correct_content == true && @correct_ct == false

                if @performance
                  if params[:n].to_i < 1
                    puts "el tiempo en la pregunta deeping 1 fue: " + seconds_in.to_s + " --------------------------------"
                    @performance.deeping_qt1_time = seconds_in
                    @performance.deeping_content1 = 1.0
                    @performance.deeping_ct1 = 0.0
                  else
                    puts "el tiempo en la pregunta deeping 2 fue: " + seconds_in.to_s + " --------------------------------"
                    @performance.deeping_qt2_time = seconds_in
                    @performance.deeping_content2 = 1.0
                    @performance.deeping_ct2 = 0.0
                  end       
                  
                  
                  if @performance.content_sc.nil?
                    @performance.content_sc = 1
                  else
                    @performance.content_sc = @performance.content_sc + 1
                  end  
                  if @performance.content_n.nil?
                    @performance.content_n = 1
                  else
                    @performance.content_n = @performance.content_n.to_i + 1
                  end 

                  @tree.deeping_ct_question.ct_habilities.each do |hab|
                    
                    puts hab.name.to_s
                    if hab.active
                      if hab.name.to_s == "Interpretación"
                        if @performance.interpretation_sc.nil?
                          @performance.interpretation_sc = 0
                        else
                          @performance.interpretation_sc = @performance.interpretation_sc
                        end
                        if @performance.interpretation_n.nil?
                          @performance.interpretation_n = 1
                        else
                          @performance.interpretation_n = @performance.interpretation_n.to_i + 1
                        end                       
                      elsif hab.name.to_s == "Análisis"
                        if @performance.analysis_sc.nil?
                          @performance.analysis_sc = 0
                        else
                          @performance.analysis_sc = @performance.analysis_sc
                        end
                        if @performance.analysis_n.nil?
                          @performance.analysis_n = 1
                        else
                          @performance.analysis_n = @performance.analysis_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Evaluación"
                        if @performance.evaluation_sc.nil?
                          @performance.evaluation_sc = 0
                        else
                          @performance.evaluation_sc = @performance.evaluation_sc
                        end
                        if @performance.evaluation_n.nil?
                          @performance.evaluation_n = 1
                        else
                          @performance.evaluation_n = @performance.evaluation_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Inferencia"
                        if @performance.inference_sc.nil?
                          @performance.inference_sc = 0
                        else
                         @performance.inference_sc = @performance.inference_sc
                        end
                        if @performance.inference_n.nil?
                          @performance.inference_n = 1
                        else
                          @performance.inference_n = @performance.inference_n.to_i + 1
                        end  
                      elsif hab.name.to_s == "Explicación"
                        if @performance.explanation_sc.nil?
                          @performance.explanation_sc = 0
                        else
                          @performance.explanation_sc = @performance.explanation_sc
                        end
                        if @performance.explanation_n.nil?
                          @performance.explanation_n = 1
                        else
                          @performance.explanation_n = @performance.explanation_n.to_i + 1
                        end
                      elsif hab.name.to_s == "Autoregulación"
                        if @performance.selfregulation_sc.nil?
                          @performance.selfregulation_sc = 0
                        else
                          @performance.selfregulation_sc = @performance.selfregulation_sc
                        end
                        if @performance.selfregulation_n.nil?
                          @performance.selfregulation_n = 1
                        else
                          @performance.selfregulation_n = @performance.selfregulation_n.to_i + 1
                        end 
                      end
                    end
                  end
                end
               #if params[:n].to_i == 0
                render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
                :feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
                 :type => "deeping", :state =>"answered", :feedback_quality => "simple", :n => params[:n].to_i, :content_choices => params[:content_choices], :ct_choices => params[:ct_choices], :initial_time => Time.now.to_i}
               #else
                #render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
                #:feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
                 #:type => "deeping", :state =>"answered", :feedback_quality => "none", :n => params[:n].to_i, :content_choices => params[:content_choices], :ct_choices => params[:ct_choices]}

               #end

              else

                if @performance
                  if params[:n].to_i < 1
                    puts "el tiempo en la pregunta deeping 1 fue: " + seconds_in.to_s + " --------------------------------"
                    @performance.deeping_qt1_time = seconds_in
                    @performance.deeping_content1 = 0.0
                    if @correct_ct == true
                      @performance.deeping_ct1 = 1.0
                    else
                      @performance.deeping_ct1 = 0.0
                    end
                  else
                    puts "el tiempo en la pregunta deeping 2 fue: " + seconds_in.to_s + " --------------------------------"
                    @performance.deeping_qt2_time = seconds_in
                    @performance.deeping_content2 = 0.0
                    if @correct_ct == true
                      @performance.deeping_ct2 = 1.0
                    else
                      @performance.deeping_ct2 = 0.0
                    end
                  end       
                  

                  if @performance.content_sc.nil?
                    @performance.content_sc = 0
                  else
                    @performance.content_sc = @performance.content_sc
                  end
                  if @performance.content_n.nil?
                    @performance.content_n = 1
                  else
                    @performance.content_n = @performance.content_n.to_i + 1
                  end  

                  @tree.deeping_ct_question.ct_habilities.each do |hab|
                    if hab.active
                     
                      puts hab.name.to_s
                      if hab.name.to_s == "Interpretación"
                        if@performance.interpretation_sc.nil?
                          @performance.interpretation_sc = 0
                        else
                          @performance.interpretation_sc = @performance.interpretation_sc
                        end
                        if @performance.interpretation_n.nil?
                          @performance.interpretation_n = 1
                        else
                          @performance.interpretation_n = @performance.interpretation_n.to_i + 1
                        end                      
                      elsif hab.name.to_s == "Análisis"
                        if @performance.analysis_sc.nil?
                          @performance.analysis_sc = 0
                        else
                         @performance.analysis_sc = @performance.analysis_sc
                        end
                        if @performance.analysis_n.nil?
                          @performance.analysis_n = 1
                        else
                          @performance.analysis_n = @performance.analysis_n.to_i + 1
                        end  
                      elsif hab.name.to_s == "Evaluación"
                        if @performance.evaluation_sc.nil?
                          @performance.evaluation_sc = 0
                        else
                          @performance.evaluation_sc = @performance.evaluation_sc
                        end
                        if @performance.evaluation_n.nil?
                          @performance.evaluation_n = 1
                        else
                          @performance.evaluation_n = @performance.evaluation_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Inferencia"
                        if @performance.inference_sc.nil?
                          @performance.inference_sc = 0
                        else
                          @performance.inference_sc = @performance.inference_sc
                        end
                        if @performance.inference_n.nil?
                          @performance.inference_n = 1
                        else
                          @performance.inference_n = @performance.inference_n.to_i + 1
                        end 
                      elsif hab.name.to_s == "Explicación"
                        if @performance.explanation_sc.nil?
                          @performance.explanation_sc = 0
                        else
                          @performance.explanation_sc = @performance.explanation_sc
                        end
                        if @performance.explanation_n.nil?
                          @performance.explanation_n = 1
                        else
                          @performance.explanation_n = @performance.explanation_n.to_i + 1
                        end
                      elsif hab.name.to_s == "Autoregulación"
                        if @performance.selfregulation_sc.nil?
                          @performance.selfregulation_sc = 0
                        else
                          @performance.selfregulation_sc = @performance.selfregulation_sc
                        end
                        if @performance.selfregulation_n.nil?
                          @performance.selfregulation_n = 1
                        else
                          @performance.selfregulation_n = @performance.selfregulation_n.to_i + 1
                        end 
                      end
                    end
                  end
                end
                  
               # if params[:n].to_i == 0
                  render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
                :feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
                 :type => "deeping", :state => "answered", :feedback_quality => "complex", :n => params[:n].to_i, :content_choices => params[:content_choices], :ct_choices => params[:ct_choices], :initial_time => Time.now.to_i}
                #else
                  #render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
                #:feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
                 #:type => "deeping", :state =>"answered", :feedback_quality => "none", :n => params[:n].to_i, :content_choices => params[:content_choices], :ct_choices => params[:ct_choices]}

                #end
              end

      else
        #if !@performance.deeping_qt2_time.nil?
         # @performance.deeping_fb2_time = seconds_in
          #puts "le doy tiempo al deeping fb2 que es: " + seconds_in.to_s + " en el if tiempo deeping_qt2 no es nul"
        #end
        #puts "el tiempo podría ser del deeping fb2 " + seconds_in.to_s + " fuera dle if de tiempo deeping_qt2 no es nul"
        @performance.finish_tree_time = Time.now
        if @performance.start_tree_time
        @performance.total_time = Time.now - @performance.start_tree_time
        end
        learner_user = User.find(@performance.user_id)
        if(learner_user.role != "alumno")
          @performance.destroy
        end
        puts "guarde el tiempo final saliendo en finalizar.................................."
        render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
                  :feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
                  :type => "deeping", :state => "end", :feedback_quality => "none", :n => 2, :content_choices => params[:content_choices], :ct_choices => params[:ct_choices], :initial_time => Time.now.to_i}
          #var win = window.open("about:blank", "_self");
          #win.close();
      end

      elsif params[:state].to_s == "feedback_seen"
        
        if params[:n].to_i < 2
          puts "le doy tiempo al deeping fb1 que es: " + seconds_in.to_s + "------------------------------ feedbackseed "
          @performance.deeping_fb1_time = seconds_in
          render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
            :feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
            :type => "deeping", :state =>"not_seen", :feedback_quality => "none", :n => params[:n].to_i, :content_choices => params[:content_choices], :ct_choices => params[:ct_choices], :initial_time => Time.now.to_i}

        else
          puts "le doy tiempo al deeping fb2 que es: " + seconds_in.to_s + "------------------------------ feedbackseen  "
          @performance.deeping_fb2_time = seconds_in
          @performance.finish_tree_time = Time.now
          if !@performance.start_tree_time.nil?
          @performance.total_time = Time.now - @performance.start_tree_time
          end
          learner_user = User.find(@performance.user_id)
          if(learner_user.role != "alumno")
            @performance.destroy
          end
          puts "guarde el tiempo final luego de ver el 2do feedback...................................."
          render "edx_view", :locals => {:content_question => @tree.deeping_content_question, :ct_question => @tree.deeping_ct_question,
              :feedback_simple=> @tree.deeping_simple_feedback, :feedback_complex => @tree.deeping_complex_feedback,
              :type => "deeping", :state => "end", :feedback_quality => "none", :n => 2, :content_choices => params[:content_choices], :ct_choices => params[:ct_choices], :initial_time => Time.now.to_i}

        end

      end
    end




    if @performance.nil?
    else
      
      learner_user = User.find(@performance.user_id)
      puts learner_user.role
      if(learner_user.role == "alumno")
        @performance.save!
        puts @performance.inspect
        puts "se guardoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
      else
        #@performance.delete

        puts "no se guardooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
        puts learner_user.inspect
      end

      #@performance.save
      #puts @performance.inspect
    end

  end

  def change_initial
       @initial = false
       edx_view
  end

  # GET /trees
  # GET /trees.json
  def index
    @trees = Tree.includes(:content, :course, :video, :replies).joins(:content).where(course_id: params[:course_id]).order('contents.text').all
  end

  # GET /trees/1
  # GET /trees/1.json
  def show
    respond_with @tree, include: '**'
  end

  # GET /trees/new
  def new
    @videos = @course.videos
    @breadcrumbs = ["Mis Cursos", @course.name, "Evaluación Formativa", "Nueva evaluación de video"]
    @tree = Tree.new

    @tree.build_content

    @tree.build_initial_content_question
    4.times { @tree.initial_content_question.content_choices.build }

    @tree.build_initial_ct_question
    4.times { @tree.initial_ct_question.ct_choices.build }
    #6.times { @tree.initial_ct_question.ct_habilities.build }
    build_habilities @tree.initial_ct_question
    
    @tree.build_recuperative_content_question
    4.times { @tree.recuperative_content_question.content_choices.build }

    @tree.build_recuperative_ct_question
    4.times { @tree.recuperative_ct_question.ct_choices.build }
    # 6.times { @tree.recuperative_ct_question.ct_habilities.build }
    build_habilities @tree.recuperative_ct_question

    @tree.build_deeping_content_question
    4.times { @tree.deeping_content_question.content_choices.build }

    @tree.build_deeping_ct_question
    4.times { @tree.deeping_ct_question.ct_choices.build }
    # 6.times { @tree.deeping_ct_question.ct_habilities.build }
    build_habilities @tree.deeping_ct_question

    @tree.build_initial_simple_feedback
    @tree.build_initial_complex_feedback
    @tree.build_recuperative_simple_feedback
    @tree.build_recuperative_complex_feedback
    @tree.build_deeping_simple_feedback
    @tree.build_deeping_complex_feedback

  end

  # GET /trees/1/edit
  def edit
    @videos = @course.videos
    @breadcrumbs = ["Mis Cursos", @course.name, "Evaluación Formativa", "Editar evaluación de video"]
    @tree.build_content if @tree.content.nil?
    @tree.build_initial_content_question if @tree.initial_content_question.nil?
    @tree.build_initial_ct_question if @tree.initial_ct_question.nil?
    @tree.build_recuperative_content_question if @tree.recuperative_content_question.nil?
    @tree.build_recuperative_ct_question if @tree.recuperative_ct_question.nil?
    @tree.build_deeping_content_question if @tree.deeping_content_question.nil?
    @tree.build_deeping_ct_question if @tree.deeping_content_question.nil?


    @tree.build_initial_simple_feedback if @tree.initial_simple_feedback.nil?
    @tree.build_initial_complex_feedback if @tree.initial_complex_feedback.nil?
    @tree.build_recuperative_simple_feedback if @tree.recuperative_simple_feedback.nil?
    @tree.build_recuperative_complex_feedback if @tree.recuperative_complex_feedback.nil?
    @tree.build_deeping_simple_feedback if @tree.deeping_simple_feedback.nil?
    @tree.build_deeping_complex_feedback if @tree.deeping_complex_feedback.nil?

  end

  # POST /trees
  # POST /trees.json
  def create
    #@tree = Tree.new(tree_params)
    #@course = Course.find(:course_id)
    @tree = @course.trees.new(tree_params)


    respond_to do |format|
      if @tree.save
        format.html { redirect_to [@course, @tree], notice: 'Tree was successfully created.' }
        format.json { render :show, status: :created, location: @tree }
      else
        format.html { render :new }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trees/1
  # PATCH/PUT /trees/1.json
  def update
    # render json: tree_params and return
    respond_to do |format|
      if @tree.update(tree_params)
        format.html { redirect_to [@tree.course, @tree], notice: 'Tree was successfully updated.' }
        format.json { render :show, status: :ok, location: @tree }
      else
        format.html { render :edit }
        format.json { render json: @tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trees/1
  # DELETE /trees/1.json
  def destroy
    @tree.destroy
    respond_to do |format|
      format.html { redirect_to @course, notice: 'Tree was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def user_info
    @course = Course.find(params[:course_id])
    @tree = @course.trees.find(params[:tree_id])
    @user_performance = @tree.user_tree_performances.find_by(user_id: params[:user_id])
    @breadcrumbs = ["Mis Cursos", @course.name, "Reportes", "Reportes de Alumnos"]
    puts "aca desde controler.............-------"
    puts params[:user_id].to_s
    @the_user = User.find(params[:user_id])
    render 'user_tree_performance'
  end

  def tree_performance


    
    @users_sc = Hash.new
    @course = Course.find(params[:course_id])
    @tree = @course.trees.find(params[:tree_id])
    @breadcrumbs = ["Mis Cursos", @course.name, "Reportes", "Reportes de Alumnos"]


    @tree.user_tree_performances.each do |performance|
      if performance
          if performance.content_sc
          content_sc = (performance.content_sc / performance.content_n).round(2)
          end
          if performance.interpretation_sc
          interpretation_sc = (performance.interpretation_sc / performance.interpretation_n).round(2)
          end
          if performance.analysis_sc
          analysis_sc = (performance.analysis_sc / performance.analysis_n).round(2)
          end
          if performance.evaluation_sc
          evaluation_sc = (performance.evaluation_sc / performance.evaluation_n).round(2)
          end
          if performance.inference_sc
          inference_sc = (performance.inference_sc / performance.inference_n).round(2)
          end
          if performance.explanation_sc
          explanation_sc = (performance.explanation_sc / performance.explanation_n).round(2)
          end
          if performance.selfregulation_sc
          selfregulation_sc = (performance.selfregulation_sc / performance.selfregulation_n).round(2)
          end
      end
      user = User.find(performance.user_id)
      if user.role == "alumno"
        @users_sc[user.id] = {:name => user.last_name + ", " +  user.first_name, :content_sc => content_sc, :interpretation_sc => interpretation_sc,
          :analysis_sc => analysis_sc, :evaluation_sc => evaluation_sc, :inference_sc => inference_sc, :explanation_sc => explanation_sc, :selfregulation_sc => selfregulation_sc}
      end
    end

    render 'tree_performance'

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tree
      @tree = @course.trees.includes(@@includes).find(params[:id])

    end

    def set_tree_edx
      @course = Course.find(params[:course_id])
      @tree = @course.trees.find(params[:id])

    end

    def set_course
      @course = Course.find(params[:course_id])

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tree_params
      params.require(:tree).permit(:video_id, :active, :prev, :after, content_attributes: [:id, :text],
        initial_content_question_attributes: [:id, :question, :_destroy, content_choices_attributes: [:id, :text, :right, :content_question_id, :_destroy]],
        initial_ct_question_attributes: [:id, :question, :_destroy, ct_habilities_attributes: [:id, :name, :description, :active, :ct_question_id, :_destroy], ct_choices_attributes: [:id, :text, :right, :ct_question_id, :_destroy]],
        recuperative_content_question_attributes: [:id, :question, :_destroy, content_choices_attributes: [:id, :text, :right, :content_question_id, :_destroy]],
        recuperative_ct_question_attributes: [:id, :question, :_destroy, ct_habilities_attributes: [:id, :name, :description, :active, :ct_question_id, :_destroy], ct_choices_attributes: [:id, :text, :right, :ct_question_id, :_destroy]],
        deeping_content_question_attributes: [:id, :question, :_destroy, content_choices_attributes: [:id, :text, :right, :content_question_id, :_destroy]],
        deeping_ct_question_attributes: [:id, :question, :_destroy, ct_habilities_attributes: [:id, :name, :description, :active, :ct_question_id, :_destroy], ct_choices_attributes: [:id, :text, :right, :ct_question_id, :_destroy]],
        initial_simple_feedback_attributes: [:id, :text, :_destroy],
        initial_complex_feedback_attributes: [:id, :text, :_destroy],
        recuperative_simple_feedback_attributes: [:id, :text, :_destroy],
        recuperative_complex_feedback_attributes: [:id, :text, :_destroy],
        deeping_simple_feedback_attributes: [:id, :text, :_destroy],
        deeping_complex_feedback_attributes: [:id, :text, :_destroy],
        user_tree_performances_attributes: [:id, :user_id, :tree_id, :content_sc, :interpretation_sc, :analysis_sc, :evaluation_sc, :inference_sc, :explanation_sc, :selfregulation_sc, :n]
     ) 
    end

    def ct_question_params
      params.require(:tree).permit(:question, :tree_id, ct_choices_attributes: [:text, :right], ct_habilities_attributes: [:name, :description, :active])
    end

    def content_question_params
      params.require(:tree).permit(:question, :tree_id, content_choices_attributes: [:text, :right])
    end

    def set_ef_visible
      @ef_visible = true
    end

    def set_reporte_visible
      @reporte_visible = true
    end

    def set_breadcrumbs
      @breadcrumbs = []
    end

    def set_user_tree_performance
      @performance = Course.find(params[:tree_id => @tree.id, :user_id => current.user.id])
    end



end