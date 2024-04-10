require 'httparty'

namespace :seed do
  desc "Seed data from USGS Earthquake API"
  task usgs_earthquakes: :environment do

    # Clear existing data to avoid duplicates
    Feature.delete_all

    response = HTTParty.get('https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson')
    data = JSON.parse(response.body)

    data['features'].each do |feature|
      Feature.create(
        external_id: feature['id'],
        type: feature['type'],
        magnitude: feature['properties']['mag'],
        place: feature['properties']['place'], # NOT NULL
        time: Time.at(feature['properties']['time'] / 1000),
        tsunami: feature['properties']['tsunami'],
        mag_type: feature['properties']['magType'], # NOT NULL
        title: feature['properties']['title'], # NOT NULL
        longitude: feature['geometry']['coordinates'][0],
        latitude: feature['geometry']['coordinates'][1],
        external_url: feature['properties']['url'] # NOT NULL
      )
    end
  end
end
