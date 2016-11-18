set :stage, :st
set :branch, :staging
set :deploy_to, '/u01/apps/qwinix/st-city-vitality'
set :log_level, :debug

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
role :app, %w{deploy@st.peershape-api.qwinixtech.com}
role :web, %w{deploy@st.peershape-api.qwinixtech.com}
role :db, %w{deploy@st.peershape-api.qwinixtech.com}
server 'st.peershape-api.qwinixtech.com', roles: %w{:web, :app, :db}, user: 'deploy'

set :ssh_options, {
   #verbose: :debug,
   keys: %w(~/.ssh/id_rsa),
   auth_methods: %w(publickey)
}
