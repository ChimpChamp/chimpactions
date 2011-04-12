#######
# NOTE : for circuit dev box :
#   NGINX_CONFIG_PATH = /usr/local/nginx/conf/servers/
#   UNICORN_SOCK_PATH = /usr/local/unicorn/sock
#   LISTEN_PORT = 84 for five_dev
#   BASE_URL = whatever.circuitllc.com
#     yer screwed on the PORT! 
#######
  # this can be any application server, not just Unicorn/Rainbows!
  upstream unicorn_five_dev {
    # fail_timeout=0 means we always retry an upstream even if it failed
    # to return a good HTTP response (in case the Unicorn master nukes a
    # single worker for timing out).
    # for UNIX domain socket setups:
    server unix:{UNICORN_SOCK_PATH}/#{app_name}.sock fail_timeout=0;
  }
  server {
listen {LISTEN_PORT};
    client_max_body_size 4G;
    server_name {BASE_URL};
    # ~2 seconds is often enough for most folks to parse HTML/CSS and
    # retrieve needed images/icons/frames, connections are cheap in
    # nginx so increasing this is generally safe...
    keepalive_timeout 5;
    # path for static files
   root #{current_path}/public;
    location / {
      # an HTTP header important enough to have its own Wikipedia entry:
      #   http://en.wikipedia.org/wiki/X-Forwarded-For
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      #proxy_set_header X-Forwarded-Proto https;
      # pass the Host: header from the client right along so redirects
      # can be set properly within the Rack application
      proxy_set_header Host $http_host;
      # we don't want nginx trying to do something clever with
      # redirects, we set the Host: header above already.
      proxy_redirect off;
      # set "proxy_buffering off" *only* for Rainbows! when doing
      # Comet/long-poll stuff.  It's also safe to set if you're
      # using only serving fast clients with Unicorn + nginx.
      # Otherwise you _want_ nginx to buffer responses to slow
      # clients, really.
       proxy_buffering off;
          # if you are serving static files from nginx, try to serve them less
      if ($request_uri ~* "\.(ico|css|js|gif|jpe?g|png)\?[0-9]+$") {
        expires max;
        break;
      }
      # Try to serve static files from nginx, no point in making an
      # *application* server like Unicorn/Rainbows! serve static files.
      if (!-f $request_filename) {
        proxy_pass http://unicorn_#{app_name};
        break;
      }
    }
    # Rails error pages
    error_page 500 502 503 504 /500.html;
    location = /500.html {
                root #{current_path}/public;
    }

  }
