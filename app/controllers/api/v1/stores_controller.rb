# frozen_string_literal: true

module Api
  module V1
    class StoresController < ApplicationController
      def index
        render json: { message: "Stores Index!" }
      end
    end
  end
end
