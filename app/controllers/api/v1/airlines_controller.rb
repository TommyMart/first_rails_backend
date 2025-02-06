module Api
  module V1
    class AirlinesController < ApplicationController
      protect_from_forgery with: :null_session

      def index
        airlines = Airline.all

        render json: AirlineSerializer.new(airlines, options).serializable_hash.to_json
      end

      def show
        airline = Airline.find_by(slug: params[:slug])
        if airline
        render json: AirlineSerializer.new(airline, options).serializable_hash.to_json
        else
          render json: { error: "Airline not found" }, status: :not_found
        end
      end

      def create
        airline = Airline.new(airline_params)

        if airline.save
          # Return the newly created airline in JSON format
          render json: AirlineSerializer.new(airline).serializable_hash.to_json, status: :created
        else
          # Return an error message if saving fails
          render json: { error: airline.errors.messages }, status: :unprocessable_entity
        end
      end

      def update
        airline = Airline.find_by(slug: params[:slug])

        if airline.update(airline_params)
          # Return the newly created airline in JSON format
          render json: AirlineSerializer.new(airline, options).serializable_hash.to_json, status: :created
        else
          # Return an error message if saving fails
          render json: { error: airline.errors.messages }, status: :unprocessable_entity
        end
      end

      def destroy
        airline = Airline.find_by(slug: params[:slug])

        if airline.destroy
          head :no_content
        else
          # Return an error message if saving fails
          render json: { error: airline.errors.messages }, status: :unprocessable_entity
        end
      end

      private

      def airline_params
        params.required(:airline).permit(:name, :image_url)
      end

      def options
        @options ||= { include: %i[reviews] }
      end
    end
  end
end
