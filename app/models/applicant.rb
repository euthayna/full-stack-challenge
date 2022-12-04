# frozen_string_literal: true

# Applications to Projects
class Applicant < ApplicationRecord
  belongs_to :project
  has_many :status_transitions, dependent: :destroy
  accepts_nested_attributes_for :status_transitions

  validates :name, presence: true, uniqueness: true
  validates :overview, presence: true
  validates :funding, numericality: true, presence: true

  def status
    status_transitions.last
  end
end
