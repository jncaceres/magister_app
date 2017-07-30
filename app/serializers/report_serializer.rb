class ReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :interpretation_sc, :analysis_sc, :evaluation_sc, :inference_sc, :explanation_sc, :selfregulation_sc, :content_sc
  has_one :course
  has_many :trees
end
