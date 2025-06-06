module Tray
  class AuthController < ApplicationController
    # https://localhost:3000/tray/callback?store=1225878&adm_user=hortifertil&store_host=https://1225878.commercesuite.com.br
    def callback
      # Get callback params
      # tray_store_id = params[:store]
      # adm_user = params[:adm_user]
      # store_host = params[:url]


      Tray::AuthorizationGrantService.new()

      # ---------------------------------------------------------------
      # Find or Create
      # Store.create(store_id: tray_store_id, adm_user: adm_user, store_host: store_host)
      finded_or_created_store = Tray::FindOrCreate.call(params: callback_params)

      # Callback Query Params
      query_params = {
        response_type: "code",
        consumer_key: ENV["TRAY_CONSUMER_KEY"],
        callback: "#{ENV["APP_HOST"]}/tray/callback/auth"
      }

      # Mount Authentication URL
      auth_url = "#{finded_or_created_store.store_host}/auth.php"
      query_string = query_params.to_query
      uri = URI(auth_url)
      uri.query = query_string

      # Redirect to Auth URL
      redirect_to uri.to_s, allow_other_host: true
    end

    def auth_callback
      # Get Auth callback params
      code = params[:code]
      api_address = params[:api_address]
      tray_store_id = params[:store]

      # Update Store by StoreId
      store = Store.find_by!(store_id: tray_store_id)
      store.update!(code: code, api_address: api_address)

      # Auth callback params
      query_params = {
        consumer_key: ENV["TRAY_CONSUMER_KEY"],
        consumer_secret: ENV["TRAY_CONSUMER_SECRET"],
        code: code
      }

      # Mount GetAccessKeys URL
      uri = URI.parse("#{api_address}/auth")
      req = Net::HTTP::Post.new(uri)
      req.set_form_data(query_params)

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      if res.is_a?(Net::HTTPSuccess)
        json = JSON.parse(res.body)

        # Insert Access Keys on store
        store.update!(
          access_token: json["access_token"],
          refresh_token: json["refresh_token"],
          token_expires_at: json["date_expiration_access_token"]
        )

        render json: { message: "Auth callback concluído com sucesso!" }, status: :ok
      else
        Rails.logger.error("Erro ao obter tokens: #{res.body}")
        render json: { message: "Erro ao autenticar na Tray" }, status: :unprocessable_entity
      end
    end

    def callback_params
      params.permit(
        :store,
        :adm_user,
        :url
      )
    end
  end
end
