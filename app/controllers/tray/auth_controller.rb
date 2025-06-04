module Tray
  class AuthController < ApplicationController
    def start
      tray_store_id = params[:store]
      adm_user = params[:adm_user]
      store_host = params[:store_host]

      Store.create!(store_id: tray_store_id, adm_user: adm_user, store_host: store_host)
      auth_url = "#{store_host}/auth.php"
      # https://1225878.commercesuite.com.br
      query_params = {
        response_type: "code",
        consumer_key: "CONSUMER_KEY", # ENV["TRAY_CONSUMER_KEY"]
        callback: "https://www.postlink.com.br/tray/callback/auth"
      }
      uri = URI(auth_url)
      uri.query = query_params.to_query

      redirect_to uri.to_s
    end

    def callback
      render json: { message: "callback action!" }
    end

    def auth_callback
      code = params[:code]
      api_address = params[:api_address]
      tray_store_id = params[:store]

      store = Store.find_by!(store_id: tray_store_id)
      store.update!(code: code, api_address: api_address)

      query_params = {
        consumer_key: "CONSUMER_KEY", # ENV["TRAY_CONSUMER_KEY"]
        consumer_secret: ENV["TRAY_CONSUMER_SECRET"],
        code: code
      }

      uri = URI.parse(api_address)
      req = Net::HTTP::Post.new(uri)
      req.set_form_data(query_params)

      access_token = params[:access_token]
      refresh_token = params[:refresh_token]
      date_expiration_access_token = params[:date_expiration_access_token]

      store.update!(access_token: access_token,
          refresh_token: refresh_token,
          token_expires_at: date_expiration_access_token
        )
    end
  end
end
