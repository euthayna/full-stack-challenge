# frozen_string_literal: true

# ApplicationHelper
module ApplicationHelper
  def current_status?(applicant_form, status_form)
    applicant_form.object.status == status_form.object
  end
end
