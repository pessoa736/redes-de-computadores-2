#!/bin/sh

until getent hosts app-super-fodastico-1.DomainExpansion.com \
   && getent hosts app-super-fodastico-2.DomainExpansion.com; do

  echo "aguardando DNS de app1/app2..."
  
  sleep 1
done