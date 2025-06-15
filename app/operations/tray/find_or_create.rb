module Tray
  class FindOrCreate < Actor
    input :params, type: Hash

    output :store, type: Store

    def call
      self.store = find_store || create_store
    end

    def find_store
      Store.find_by!(store_id: params[:store]) if params[:store]
    end

    def create_store
      Store.create!(store_id: params[:store], adm_user: params[:adm_user], store_host: params[:url])
    end
  end
end
