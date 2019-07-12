#!/bin/sh
set -v
sudo -u apache -g apache cp globe.html /srv/httpd/htdocs
sudo -u apache -g apache cp globe.js /srv/httpd/htdocs
sudo -u apache -g apache cp globe.pl /srv/httpd/cgi-bin
