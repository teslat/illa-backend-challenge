class TruckLog < ApplicationRecord
    attribute :centroid, :st_point, srid: 4326, geographic: true
    belongs_to :truck
end
