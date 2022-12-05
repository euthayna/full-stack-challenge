# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe 'applicants/index' do
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

  let(:applicant1) do
    Applicant.create!(
      name: 'Applicant 1',
      overview: 'Overview',
      funding: 500,
      project:
    )
  end

  let(:applicant2) do
    Applicant.create!(
      name: 'Applicant 2',
      overview: 'Overview',
      funding: 500,
      project:
    )
  end

  let(:status_transition_applicant1) { StatusTransition.create!(name: 'applied', applicant_id: applicant1.id) }
  let(:status_transition_applicant2) { StatusTransition.create!(name: 'approved', applicant_id: applicant2.id) }

  before do
    status_transition_applicant1
    status_transition_applicant2
    assign(:applicants, [applicant1, applicant2])
  end

  it 'renders a list of applicants' do
    render
    cell_selector = 'tr>td'
    assert_select cell_selector, text: Regexp.new('Applicant'), count: 2
    assert_select cell_selector, text: 'Project', count: 2
    assert_select cell_selector, text: 'Applied', count: 1
    assert_select cell_selector, text: 'Approved', count: 1
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
