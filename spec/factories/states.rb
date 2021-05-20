# frozen_string_literal: true

FactoryBot.define do
  factory :state do
    name { 'Rio de Janeiro' }
    uf { 'RJ' }
    location_id { 33 }
    population2019 { 17_264_943 }
  end
end
