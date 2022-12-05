# frozen_string_literal: true

# rubocop:disable Rails/ApplicationRecord
class AddsStatusTransitions < ActiveRecord::Migration[7.0]
  class StatusTransition < ActiveRecord::Base; end
  class Applicant < ActiveRecord::Base; end

  def up
    create_table :status_transitions do |t|
      t.references :applicant, null: false, foreign_key: true
      t.integer :name
      t.text :comment

      t.timestamps
    end

    Applicant.find_each do |applicant|
      # name is an enum just like the old status column in applicant, that's why
      # we're copying the source integer here
      StatusTransition.create!(applicant_id: applicant.id, name: applicant.status)
    end

    remove_column :applicants, :status
  end

  def down
    add_column :applicants, :status, :integer
    add_index :applicants, :status

    Applicant.find_each do |applicant|
      current_status = current_status(applicant)

      applicant.update!(status: current_status)
    end

    drop_table :status_transitions
  end

  def current_status(applicant)
    # Name is an enum just like the old status column in applicant, that's why
    # we're copying the source integer here

    StatusTransition
      .where(applicant_id: applicant.id)
      .order(:id)
      .last!
      .name
  end
end
# rubocop:enable Rails/ApplicationRecord
