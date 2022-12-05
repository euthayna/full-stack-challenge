# frozen_string_literal: true

# Controller for management list of StatusTransitions per Applicant
class StatusTransitionsController < ApplicationController
  before_action :set_applicant, only: :index

  # GET applicant/:id/status_transitions
  def index
    @status_transitions = StatusTransition.where(applicant_id: @applicant.id)
  end

  private

  def set_applicant
    @applicant = Applicant.find(params[:applicant_id])
  end
end
