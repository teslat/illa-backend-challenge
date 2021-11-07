require 'csv'
class Api::V1::TrucksController < ApplicationController
    def create
        @truck = Truck.new
        @truck.plate_number = params[:plate_number]
        @truck.save
        render json: @truck
    end

    def summary
        @truck_logs = TruckLog.where('truck_id = ?', params[:id]).where(created_at: (params[:from_date]..params[:to_date]))
        @distance = 0
        @last_log = @truck_logs.first.geom
        @truck_logs.each do |truck_log|
            @distance += @last_log.distance(truck_log.geom) 
            @last_log = truck_log.geom
        end
        render json: @distance 
    end

    def active
        @trucks = Truck.includes(:truck_logs)
            .where('truck_logs.created_at > ?', 5.minute.ago)
            .order('truck_logs.created_at DESC')
        render json: @trucks
    end

    def log
        @truck_log = TruckLog.new
        @truck_log.truck_id = params[:truck_id]
        @truck_log.longitude = params[:longitude]
        @truck_log.latitude = params[:latitude]
        @truck_log.geom = RGeo::Cartesian.factory.point(params[:longitude], params[:latitude])
        @truck_log.save
        render json: @truck_log
    end
end