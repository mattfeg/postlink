module Tray
  class AuthController < ApplicationController
    def callback
      store_id = params[:store]
      adm_user = params[:adm_user]
      url = params[:url]

      render json: { message: "callback action!- [TRAY][CALLBACK] store=#{store_id}, adm_user=#{adm_user}, url=#{url}" }
    end

    def auth_callback
      render json: { message: "auth callback action!" }
    end
  end
end
