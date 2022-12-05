# frozen_string_literal: true

# Projects for Funds and Applicants to apply for funding for
class Project < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :payment_date, presence: true

  belongs_to :fund
  has_many :applicants, dependent: :nullify
end
