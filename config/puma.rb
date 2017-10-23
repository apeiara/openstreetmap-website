# Specifies the `port` that Puma will listen on to receive requests,
# default is 3000.
port ENV.fetch('PORT') { 3000 }

# Specifies the `environment` that Puma will run in.
environment ENV.fetch('RAILS_ENV') { 'development' }

# Set socket for Puma
bind ENV.fetch('PUMA_SOCKET') { 'unix:///var/run/puma.sock' }
