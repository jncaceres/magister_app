class AddInstructionsToHomeworks < ActiveRecord::Migration
  def change
    add_column :homeworks, :responder_instruction, :string
    add_column :homeworks, :argumentar_instruction, :string
    add_column :homeworks, :rehacer_instruction, :string
  end
end
