class RenameLatitudToLatitudeInFeatures < ActiveRecord::Migration[7.1]
  def change
    rename_column :features, :latitud, :latitude
  end
end
