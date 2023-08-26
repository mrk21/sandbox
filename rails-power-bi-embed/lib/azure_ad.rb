require 'oauth2'

module AzureAd
  AppConfig = Struct.new(
    :client_id,
    :client_secret,
    :authority,
    :scopes,
    keyword_init: true
  )

  class AppClient
    def initialize(config)
      @config = config
    end

    # curl --dump-header - -XPOST https://login.microsoftonline.com/${AZURE_TENANT_ID}/oauth2/v2.0/token \
    #   -F grant_type=client_credentials \
    #   -F scope=https://analysis.windows.net/powerbi/api/.default \
    #   -F client_id=${AZURE_CLIENT_ID} \
    #   -F client_secret=${AZURE_CLIENT_SECRET}
    def acquire_token_by_client_credential
      client_id = @config.client_id
      client_secret = @config.client_secret
      token_url = File.join(@config.authority, "/oauth2/v2.0/token")
      scope = @config.scopes.join(',')

      client = OAuth2::Client.new(
        client_id,
        client_secret,
        token_url: token_url
      )

      client.client_credentials.get_token(scope: scope)
    end
  end
end
