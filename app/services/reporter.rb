class Reporter
  @@attrs = %w(content interpretation analysis evaluation inference explanation selfregulation)

  attr_accessor :report

  def initialize(report)
    @report = Report.includes(trees: :user_tree_performances).find(report.id)
  end

  def exec
    { data: @@attrs.reduce({}) do |result, att|
      result.merge!({ "#{att}_sc" => @report.trees.map do |tree|
        tree.user_tree_performances.map do |perf|
          (perf.try("#{att}_sc".to_sym) || 0) / (perf.try("#{att}_n".to_sym) || 1)
        end.reduce(&:+)
      end.reduce(&:+), "total" => @report.user_tree_performances.count
      })
    end }
  end
end