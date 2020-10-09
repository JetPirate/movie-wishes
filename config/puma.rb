# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
# port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# Local SSL support
if Rails.env.development? || Rails.env.test?
  unless File.exist?(Rails.root.join('config', 'certs', 'localhost.key'))
    def generate_root_cert(root_key)
      root_ca = OpenSSL::X509::Certificate.new
      root_ca.version = 2 # cf. RFC 5280 - to make it a "v3" certificate
      root_ca.serial = 0x0
      root_ca.subject = OpenSSL::X509::Name.parse(
        '/C=CZ/O=A1/OU=A/CN=localhost'
      )
      root_ca.issuer = root_ca.subject # root CA's are "self-signed"
      root_ca.public_key = root_key.public_key
      root_ca.not_before = Time.now
      root_ca.not_after = root_ca.not_before + 5 * 365 * 24 * 60 * 60 # 5 years
      root_ca.sign(root_key, OpenSSL::Digest::SHA256.new)
      root_ca
    end

    root_key = OpenSSL::PKey::RSA.new(2048)
    File.open(Rails.root.join('config', 'certs', 'localhost.key'), 'wb') do |f|
      f.write(root_key)
    end

    root_cert = generate_root_cert(root_key)

    File.open(Rails.root.join('config', 'certs', 'localhost.crt'), 'wb') do |f|
      f.write(root_cert)
    end
  end

  ssl_bind('0.0.0.0', '8443',
           key: Rails.root.join('config', 'certs', 'localhost.key'),
           cert: Rails.root.join('config', 'certs', 'localhost.crt'))
end