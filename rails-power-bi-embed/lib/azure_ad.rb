require "oauth2"

module AzureAd
  AppConfig = Struct.new(
    :client_id,
    :client_secret,
    :authority,
    keyword_init: true,
  )

  class AppClient
    def initialize(config, logger:)
      @config = config
      @logger = logger
    end

    # RFC 6749, 4.3. Resource Owner Password Credentials Grant
    #
    # ```sh
    # curl --dump-header /dev/stderr -XPOST https://login.microsoftonline.com/${AZURE_TENANT_ID}/oauth2/v2.0/token \
    #   -F grant_type=password \
    #   -F username=${AZURE_MASTER_USERNAME} \
    #   -F password=${AZURE_MASTER_PASSWORD} \
    #   -F scope=https://analysis.windows.net/powerbi/api/.default \
    #   -F client_id=${AZURE_CLIENT_ID} | jq
    # ```
    def acquire_token_by_username_password(username:, password:, scopes:)
      client_id = @config.client_id
      client_secret = @config.client_secret
      token_url = File.join(@config.authority, "/oauth2/v2.0/token")
      scope = scopes.join(",")

      client = OAuth2::Client.new(
        client_id,
        client_secret,
        token_url: token_url,
        logger: @logger,
      )

      client.password.get_token(username, password, scope: scope)
    end

    # RFC 6749, 4.4. Client Credentials Grant
    #
    # ```sh
    # curl --dump-header /dev/stderr -XPOST https://login.microsoftonline.com/${AZURE_TENANT_ID}/oauth2/v2.0/token \
    #   -F grant_type=client_credentials \
    #   -F scope=https://analysis.windows.net/powerbi/api/.default \
    #   -F client_id=${AZURE_CLIENT_ID} \
    #   -F client_secret=${AZURE_CLIENT_SECRET} | jq
    # ```
    def acquire_token_by_client_credential(scopes:)
      client_id = @config.client_id
      client_secret = @config.client_secret
      token_url = File.join(@config.authority, "/oauth2/v2.0/token")
      scope = scopes.join(",")

      client = OAuth2::Client.new(
        client_id,
        client_secret,
        token_url: token_url,
        logger: @logger,
      )

      client.client_credentials.get_token(scope: scope)
    end
  end
end
