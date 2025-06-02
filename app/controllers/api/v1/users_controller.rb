# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def index
        render json: { message: "User Index!" }
      end
    end
  end
end
