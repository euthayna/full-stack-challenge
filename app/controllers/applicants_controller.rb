# frozen_string_literal: true

# Controller for CRUD management of Applicants
class ApplicantsController < ApplicationController
  before_action :set_applicant, only: %i[show edit update destroy]

  # GET /applicants
  def index
    @applicants = Applicant.order(:name)
  end

  # GET /applicants/1
  def show; end

  # GET /applicants/new
  def new
    @applicant = Applicant.new
  end

  # GET /applicants/1/edit
  def edit; end

  # POST /applicants
  def create
    @applicant = Applicant.new(applicant_params)
    @applicant.status_transitions = [StatusTransition.new(name: 'applied')]

    if @applicant.save
      redirect_to @applicant, notice: 'Applicant was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applicants/1
  def update
    delete_params_status_id_when_creating_associated_record
    if @applicant.update(applicant_params)
      redirect_to @applicant, notice: 'Applicant was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /applicants/1
  def destroy
    @applicant.destroy
    redirect_to applicants_url, notice: 'Applicant was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_applicant
    @applicant = Applicant.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def applicant_params
    params.require(:applicant).permit(
      :name, :overview, :funding, :project_id,
      status_transitions_attributes: %i[id name comment]
    )
  end

  # We have a has_many association between Applicant and StatusTransition,
  # however we want to show in the form only the latest/current one. That way
  # users can still edit the comment for the current status, or add a new comment.
  def delete_params_status_id_when_creating_associated_record
    # Rails generates <input>'s with pattern model[association][3][column]. The form
    # is rendering only one association, so we use values.first to get that single
    # one association.
    status_params = params.dig('applicant', 'status_transitions_attributes')&.values&.first
    return if status_params.blank?

    # When rendering the edit form, we're editing the StatusTransition record. However, in
    # case we're selecting a different status, let's delete the `id` from the hash so the
    # new record is created.
    status_params.delete('id') if @applicant.status.name != status_params['name']
  end
end
