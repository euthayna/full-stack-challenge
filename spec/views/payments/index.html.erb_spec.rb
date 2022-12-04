# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'payments/index.html.erb' do
  let(:fund) do
    Fund.create!(
      title: 'Fund',
      total: 10_000
    )
  end

  let(:project) do
    Project.create!(
      payment_date: Date.current + 1.month,
      title: 'Project 1',
      fund:
    )
  end

  let(:project2) do
    Project.create!(
      payment_date: Date.current + 2.months,
      title: 'Project 2',
      fund:
    )
  end

  before do
    Applicant.create!(
      name: 'Applicant 1',
      overview: 'Overview',
      funding: 500,
      project:
    )

    StatusTransition.create!(name: 'applied', applicant_id: Applicant.first.id)
    Applicant.create!(
      name: 'Applicant 2',
      overview: 'Overview',
      funding: 500,
      project: project2
    )

    StatusTransition.create!(name: 'approved', applicant_id: Applicant.second.id)
  end

  it 'renders a list of payments' do
    render

    cell_selector = 'tr>td'
    assert_select cell_selector, text: project.payment_date.to_s, count: 1
    assert_select cell_selector, text: project2.payment_date.to_s, count: 1
    assert_select cell_selector, text: 'Applicant 1', count: 0
    assert_select cell_selector, text: 'Applicant 2', count: 1
    assert_select cell_selector, text: 'Project 1', count: 1
    assert_select cell_selector, text: 'Project 2', count: 1
  end
end
