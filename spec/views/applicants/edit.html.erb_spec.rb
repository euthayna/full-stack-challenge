# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'applicants/edit' do
  let(:fund) do
    Fund.create!(
      title: 'Fund',
      total: 10_000
    )
  end

  let(:project) do
    Project.create!(
      payment_date: Date.current + 1.month,
      title: 'Project',
      fund:
    )
  end

  let(:applicant) do
    Applicant.create!(
      name: 'Applicant Name',
      overview: 'Overview',
      funding: 1,
      project:
    )
  end

  let(:status_transition) { StatusTransition.create!(name: 'applied', applicant_id: applicant.id) }

  before do
    status_transition
    assign(:applicant, applicant)
  end

  it 'renders the edit applicant form' do
    render

    assert_select 'form[action=?][method=?]', applicant_path(applicant), 'post' do
      assert_select 'input[name=?]', 'applicant[name]'

      assert_select 'textarea[name=?]', 'applicant[overview]'

      assert_select 'input[name=?]', 'applicant[funding]'

      assert_select 'select[name=?]', 'applicant[project_id]'

      assert_select 'select[name=?]', 'applicant[status_transitions_attributes][0][name]'
    end
  end
end
