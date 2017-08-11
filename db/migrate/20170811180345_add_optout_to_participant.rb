class AddOptoutToParticipant < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_responses, :optout, :boolean
  end
end
