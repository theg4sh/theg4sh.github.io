# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

#user nginx;
worker_processes 1;
error_log   ${TESTS_ROOT}/tests/nginx/error.log;
pid         ${TESTS_ROOT}/tests/nginx/nginx.pid;


# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
#include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  ${TESTS_ROOT}/tests/nginx/access.log  main;
    error_log   ${TESTS_ROOT}/tests/nginx/error.log;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    proxy_cache_path      ${TESTS_ROOT}/tests/nginx/cache levels=1:2 keys_zone=myCache:8m max_size=100m inactive=1h;
    proxy_temp_path       ${TESTS_ROOT}/tests/nginx/tmp;
    client_body_temp_path ${TESTS_ROOT}/tests/nginx/tmp;
    fastcgi_temp_path     ${TESTS_ROOT}/tests/nginx/tmp;
    uwsgi_temp_path       ${TESTS_ROOT}/tests/nginx/tmp;
    scgi_temp_path        ${TESTS_ROOT}/tests/nginx/tmp;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       1080 default_server;
        listen       [::]:1080 default_server;
        server_name  _;
        root         ${TESTS_ROOT};

        # Load configuration files for the default server block.
        #include /etc/nginx/default.d/*.conf;

        location / {
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }

# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2 default_server;
#        listen       [::]:443 ssl http2 default_server;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        location / {
#        }
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }

}

