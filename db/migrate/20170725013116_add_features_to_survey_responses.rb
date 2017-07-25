class AddFeaturesToSurveyResponses < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_responses, :from, :string
    add_column :survey_responses, :question1, :string
    add_column :survey_responses, :question2, :string
  end
end
