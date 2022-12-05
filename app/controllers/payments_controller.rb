# frozen_string_literal: true

# Controller for upcoming Payments
class PaymentsController < ApplicationController
  def index
    @projects = Project.order(:payment_date).where('payment_date >= :date', date: Date.current).includes(:applicants)
  end
end
