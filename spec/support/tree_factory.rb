class TreeFactory
  def create
    tree = Tree.new
    tree.build_content text: Faker::Lorem.sentence

    create_stage(tree, "initial")
    create_stage(tree, "recuperative")
    create_stage(tree, "deeping")

    tree
  end

  private
  def create_stage(tree, stage)
    create_feedback(tree, stage)
    create_question(tree, stage, "content")
    create_question(tree, stage, "ct")
    assign_habilities(tree, stage)
  end

  def create_feedback(tree, stage)
    tree.send("build_#{stage}_simple_feedback",  text: Faker::Lorem.sentence)
    tree.send("build_#{stage}_complex_feedback", text: Faker::Lorem.sentence)
  end

  def create_question(tree, stage, type)
    question = tree.send("build_#{stage}_#{type}_question", { question: Faker::Lorem.sentence })

    4.times do
      create_choice(question)
    end

    question.choices.sample.right = true
  end

  def create_choice(question)
    question.choices.build text: Faker::Lorem.sentence, right: false
  end

  def assign_habilities(tree, stage)
    h1, h2 = %w(Interpretación Análisis Evaluación Inferencia Explicación Autoregulación).sample(2)

    tree.send("#{stage}_ct_question").ct_habilities.build name: h1, active: true
    tree.send("#{stage}_ct_question").ct_habilities.build name: h2, active: true
  end
end