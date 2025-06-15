module Tray
  # Serviço responsável por lidar com o fluxo de concessão de autorização (Authorization Grant)
  #
  # Exemplo de uso:
  #   OAuth::AuthorizationsGrantService.new.call(code: "abc", ...)
  #
  # Parâmetros esperados:
  # - code: Código de autorização recebido
  # - client_id: Identificador do cliente (opcional)
  #
  # Retorna:
  # - Hash com os tokens de acesso e refresh
  #
  # Lança:
  # - StandardError caso ocorra falha na integração
  #
  class AuthorizationGrantService
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

    attr_reader :params

    def initialize(params)
      @callback_params = params
    end

    def mount_authentication_url
    end

    def query_params
    end
  end
end
