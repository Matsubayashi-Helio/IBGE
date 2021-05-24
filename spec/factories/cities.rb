# frozen_string_literal: true

FactoryBot.define do
  factory :city do
    name { 'Campinas' }
    location_id { 3_509_502 }
    population2019 { 1_204_073 }
  end
end
