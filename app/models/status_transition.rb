# frozen_string_literal: true

# Status Transitions for Applicants
class StatusTransition < ApplicationRecord
  attribute :name, :integer, default: 0

  belongs_to :applicant, inverse_of: :status_transitions

  enum name: { applied: 0, initial_review: 1, more_information_required: 2, declined: 3, approved: 4 }
end
