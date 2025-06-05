module Tray
  class AuthController < ApplicationController
    # https://localhost:3000//tray/start?store=1225878&adm_user=hortifertil&store_host=https://1225878.commercesuite.com.br
    def start
      puts "Start started!"
      tray_store_id = params[:store]
      adm_user = params[:adm_user]
      store_host = params[:store_host]

      Store.create(store_id: tray_store_id, adm_user: adm_user, store_host: store_host)
      auth_url = "#{store_host}/auth.php"
      puts "Store created!"

      # https://1225878.commercesuite.com.br
      # query_params = {
      #   response_type: "code",
      #   consumer_key: ENV["TRAY_CONSUMER_KEY"],
      #   callback: "https://localhost:3000/tray/callback/auth" # "https://www.postlink.com.br/tray/callback/auth"
      # }

      # Click "Install" button step on Iframe (Skipped)

      # uri = URI.parse(auth_url)
      # req = Net::HTTP::Post.new(uri)
      # req.set_form_data(query_params)

      puts "Key: #{ENV["TRAY_CONSUMER_KEY"]}"
      puts "Secret: #{ENV["TRAY_CONSUMER_SECRET"]}"

      query_params = {
        response_type: "code",
        consumer_key: ENV["TRAY_CONSUMER_KEY"]
      }

      # Monta a query sem codificar o callback
      query_string = query_params.to_query + "&callback=https://localhost:3000/tray/callback/auth"

      uri = URI(auth_url)
      uri.query = query_string

      # uri = URI(auth_url)
      # uri.query = query_params.to_query

      redirect_to uri.to_s, allow_other_host: true

      # Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      #   http.request(req)
      # end
    end

    def callback
      render json: { message: "callback action!" }
    end

    def auth_callback
      puts "Auth callback started!"
      code = params[:code]
      api_address = params[:api_address]
      tray_store_id = params[:store]

      store = Store.find_by!(store_id: tray_store_id)
      store.update!(code: code, api_address: api_address)
      puts "Inserting code and api_address!"
      query_params = {
        consumer_key: ENV["TRAY_CONSUMER_KEY"],
        consumer_secret: ENV["TRAY_CONSUMER_SECRET"],
        code: code
      }
      puts "Key: #{ENV["TRAY_CONSUMER_KEY"]}"
      puts "Secret: #{ENV["TRAY_CONSUMER_SECRET"]}"

      uri = URI.parse("#{api_address}/auth")
      req = Net::HTTP::Post.new(uri)
      req.set_form_data(query_params)

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      if res.is_a?(Net::HTTPSuccess)
        json = JSON.parse(res.body)

        store.update!(
          access_token: json["access_token"],
          refresh_token: json["refresh_token"],
          token_expires_at: json["date_expiration_access_token"]
        )
        puts "Inserting Tokens!"
        render json: { message: "Auth callback concluído com sucesso!" }, status: :ok
      else
        Rails.logger.error("Erro ao obter tokens: #{res.body}")
        render json: { message: "Erro ao autenticar na Tray" }, status: :unprocessable_entity
      end
    end
  end
end
