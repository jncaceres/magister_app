class Cloner
  attr_accessor :origin, :target, :error

  def initialize(origin, target)
    @origin = Course.find origin
    @target = Course.find target
  end

  def exec
    if self.target.trees.any? or self.target.homeworks.any?
      @error = "Curso #{@target.name} no está vacío"

      self
    else
      self
        .clone_homeworks
        .clone_questions
        .clone_videos
    end
  end

  def clone_homeworks
    unless self.target.homeworks.any?
      self.origin.homeworks.each do |hw|
        self.target.homeworks.build name: hw.name, content: hw.content
      end
    end

    self
  end

  def clone_questions # TODO: work
    t_types = %w(initial recuperative deeping)
    q_types = %w(content ct)
    f_types = %w(simple complex)

    origin.trees.each do |origin_tree|
      target_tree = target.trees.build

      target_tree.build_content text: origin_tree.content.text

      build_attribs(t_types, q_types, "question").each do |att|
        origin_question = origin_tree.send(att)
        target_question = target_tree.send("build_" + att, { question: origin_question.question, type: origin_question.type })

        if origin_question.is_a? ContentQuestion
          origin_question.content_choices.each do |choice|
            target_question.content_choices.build text: choice.text, right: choice.right
          end
        elsif origin_question.is_a? CtQuestion
          origin_question.ct_choices.each do |choice|
            target_question.ct_choices.build text: choice.text, right: choice.right
          end

          origin_question.ct_habilities.each do |choice|
            target_question.ct_habilities.build name: choice.name, description: choice.description
          end
        end
      end

      build_attribs(t_types, f_types, "feedback").each do |att|
        target_tree.send("build_" + att, { text: origin_tree.send(att).text, type: origin_tree.send(att).type })
      end
    end

    self
  end

  def clone_videos
    unless self.target.videos.any?
      self.origin.videos.each do |v|
        self.target.videos.build url: v.url, name: v.name, final_url: v.final_url, unit: v.unit
      end
    end

    self
  end

  def build_attribs fst, snd, trd
    fst.product(snd).map do |att|
      att
        .push(trd)
        .join("_")
    end
  end

  def save
    self.target.save
  end
end