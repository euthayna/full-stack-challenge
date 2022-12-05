# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
RSpec.describe 'applicant' do
  let(:fund) { Fund.create!(title: 'Fund', total: 10_000) }
  let(:project) { Project.create!(payment_date: Date.current + 1.month, title: 'Project 1', fund:) }
  let(:applicant_created) { Applicant.last }

  let(:status_transition) { applicant_created.status_transitions.first }

  before do
    project
  end

  context 'when creating a new applicant' do
    before do
      project
      visit new_applicant_url
      fill_in 'Name', with: 'Applicant 1'
      fill_in 'Overview', with: 'Overview 1'
      fill_in 'Funding', with: 100
    end

    it 'creates the applicant' do
      expect do
        click_button('Create Applicant')
      end.to change(Applicant, :count).from(0).to(1)

      expect(page).to have_content('Applicant was successfully created.')
    end

    it 'creates a status_transition record associated' do
      expect do
        click_button('Create Applicant')
      end.to change(StatusTransition, :count).from(0).to(1)

      expect(applicant_created.status.name).to eq('applied')
      expect(applicant_created.status_transitions.last.name).to eq('applied')
    end
  end

  describe 'updating an applicant' do
    let(:applicant) do
      Applicant.create!(
        name: 'Applicant Name',
        overview: 'Overview',
        funding: 1,
        project:
      )
    end

    let(:initial_status_transition) { StatusTransition.create!(applicant:, name: 0) }

    before do
      applicant
      initial_status_transition
    end

    context 'when status is changed' do
      before do
        visit edit_applicant_url(applicant.id)
        select 'Declined', from: 'Status'
      end

      it 'creates a new status_transition record associated' do
        expect do
          click_button('Update Applicant')
        end.to change(StatusTransition, :count).from(1).to(2)

        expect(applicant.status_transitions.order(:id).map(&:name)).to eq(%w[applied declined])
        expect(applicant.status.name).to eq('declined')
      end

      it 'shows the last status_transition record on show' do
        click_button('Update Applicant')
        expect(page).to have_content('Declined')
      end

      context 'when applicant has multiple past statuses' do
        let(:initial_review_status) { StatusTransition.create!(applicant:, name: 'initial_review') }
        let(:more_information_required_status) do
          StatusTransition.create!(applicant:, name: 'more_information_required')
        end

        before do
          initial_review_status
          more_information_required_status

          visit edit_applicant_url(applicant.id)
          select 'Declined', from: 'Status'
        end

        it 'creates a new status_transition record associated' do
          expect do
            click_button('Update Applicant')
          end.to change(StatusTransition, :count).from(3).to(4)

          expect(applicant.status_transitions.order(:id).map(&:name))
            .to eq(%w[applied initial_review more_information_required declined])
          expect(applicant.status.name).to eq('declined')
        end
      end
    end

    context 'when status is not changed' do
      context 'when comment is not changed' do
        before do
          visit edit_applicant_url(applicant.id)
          fill_in 'Funding', with: 300
        end

        it 'updates sucessufully the applicant record' do
          click_button('Update Applicant')
          expect(page).to have_content('Applicant was successfully updated.')
        end

        it 'does not create a new status transition record' do
          expect do
            click_button('Update Applicant')
          end.not_to change(StatusTransition, :count)
        end

        it 'does not update the current status transition record' do
          click_button('Update Applicant')
          expect(initial_status_transition.name).to eq 'applied'
          expect(initial_status_transition.comment).to be_nil
        end
      end

      context 'when comment is changed' do
        before do
          visit edit_applicant_url(applicant.id)
          fill_in 'Comment', with: 'New Comment Message'
        end

        it 'updates sucessufully the applicant record' do
          click_button('Update Applicant')
          expect(page).to have_content('Applicant was successfully updated.')
        end

        it 'does not create a new status transition record' do
          expect do
            click_button('Update Applicant')
          end.not_to change(StatusTransition, :count)
        end

        it 'updates the current status transition record comment' do
          click_button('Update Applicant')
          expect(initial_status_transition.name).to eq 'applied'
          expect(initial_status_transition.reload.comment).to eq 'New Comment Message'
        end
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers, RSpec/NestedGroups
