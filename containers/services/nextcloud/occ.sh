#!/bin/bash

docker exec --user www-data nextcloud-app php occ $1
