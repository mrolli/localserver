#!/bin/bash

rsync -av --progress --stats /var/www/html/ /vagrant/public_html/
