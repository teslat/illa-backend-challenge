require 'csv'
class DistanceTravelledWorker
  include Sidekiq::Worker
  def perform(*args)
    @trucks = Truck.includes(:truck_logs).where(truck_logs: {created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day})
    attributes = %w{id plate_number distance} #customize columns here

    file = CSV.open("#{Rails.root}/reports/distance_travelled-#{Date.today}.csv", "w",write_headers: true, headers: attributes) do |csv|
      csv << attributes
      @trucks.each do |truck|
        @distance = 0 
        @last_log = truck.truck_logs.first.geom
        truck.truck_logs.each do |truck_log|
          @distance += @last_log.distance(truck_log.geom) 
          @last_log = truck_log.geom
        end
        csv << [truck.id, truck.plate_number,@distance]
      end
    end
    file
  end
end
