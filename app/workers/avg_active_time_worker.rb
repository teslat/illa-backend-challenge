require 'csv'
class AvgActiveTimeWorker
  include Sidekiq::Worker
  def perform(*args)
    @trucks = Truck.includes(:truck_logs).where(truck_logs: {created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day})
    attributes = %w{id avg_active_time_seconds} #customize columns here

    file = CSV.open("#{Rails.root}/reports/avg_active_time-#{Date.today}.csv", "w",write_headers: true, headers: attributes) do |csv|
      csv << attributes
      @trucks.each do |truck|
        @total_time = 0
        @logs_counter = 0
        @last_log = nil
        truck.truck_logs.each do |truck_log|
          if @logs_counter == 0
            @last_log = truck_log
            @logs_counter += 1
          end
          seconds = ((truck_log.created_at - @last_log.created_at) * 24 * 60 * 60).to_i
          if seconds > 30
            @last_log = truck_log
            @total_time += seconds
            @logs_counter += 1
          end
        end
        csv << [truck.id, @total_time/@logs_counter]
      end
    end
    file
  end
end
