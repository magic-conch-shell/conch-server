Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://www.conchshell.org'
    resource '*',
      headers: :any,
      credentials: true,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
