class AddNotNullConstraintsToFeatures < ActiveRecord::Migration[7.1]
  def change
    change_column_null :features, :title, false
    change_column_null :features, :external_url, false
    change_column_null :features, :place, false
    change_column_null :features, :mag_type, false
    change_column_null :features, :latitude, false
    change_column_null :features, :longitude, false
  end
end
