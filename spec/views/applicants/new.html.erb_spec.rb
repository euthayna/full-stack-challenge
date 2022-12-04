# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'applicants/new' do
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

  before do
    assign(:applicant, Applicant.new(
                         name: 'Applicant Name',
                         overview: 'Overview',
                         funding: 1,
                         project:
                       ))
  end

  it 'renders new applicant form' do
    render

    assert_select 'form[action=?][method=?]', applicants_path, 'post' do
      assert_select 'input[name=?]', 'applicant[name]'

      assert_select 'textarea[name=?]', 'applicant[overview]'

      assert_select 'input[name=?]', 'applicant[funding]'

      assert_select 'select[name=?]', 'applicant[project_id]'

      assert_select 'select[name=?]', 'applicant[status_transitions_attributes][0][name]', false
    end
  end
end
