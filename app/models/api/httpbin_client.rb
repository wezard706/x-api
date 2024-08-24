# frozen_string_literal: true

module Api
  class HttpbinClient
    URL = 'https://httpbin.org'
    private_constant :URL

    def get
      retry_exceptions = Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS + [SocketError, Faraday::ConnectionFailed]
      conn = Faraday.new(url: URL) do |f|
        f.request :retry, max: 3, exceptions: retry_exceptions, retry_block: -> (env:, exception:, options:, retry_count:, will_retry_in:) do
          puts "retry faraday, status: #{env.status}, exception: #{exception}, retry_count: #{retry_count}, will_retry_in: #{will_retry_in}"
        end
        f.response :raise_error
      end

      conn.get('get') do |req|
        req.options.open_timeout = 5
        req.options.read_timeout = 5
        req.options.write_timeout = 5
      end
    end
  end
end