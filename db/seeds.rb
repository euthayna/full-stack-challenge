# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 25 Funds
Fund.insert_all(Array.new(25) { |i| { title: "Fund #{i + 1}", total: rand(10..50) * 1000 } }) # rubocop:disable Rails/SkipsModelValidations
fund_ids = Fund.ids

# 75 Projects
Project.insert_all( # rubocop:disable Rails/SkipsModelValidations
  Array.new(75) do |i|
    {
      title: "Project #{i + 1}",
      fund_id: fund_ids.sample,
      payment_date: rand(30..180).days.from_now
    }
  end
)
project_ids = Project.ids

# 500 Applicants
Applicant.insert_all( # rubocop:disable Rails/SkipsModelValidations
  Array.new(500) do
    {
      name: Faker::Name.name,
      funding: rand(1..10) * 100,
      overview: Faker::Lorem.paragraph,
      project_id: project_ids.sample
    }
  end
)

# rubocop:disable Rails/SkipsModelValidations
StatusTransition.insert_all(
  Applicant.all.map do |applicant|
    {
      applicant_id: applicant.id,
      name: rand(0..4),
      comment: "Comment for applicant named #{applicant.name}"
    }
  end
)
# rubocop:enable Rails/SkipsModelValidations
