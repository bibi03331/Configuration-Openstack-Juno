#!/bin/bash

# Sauvegarde de Cinder
rsync -a /etc/cinder openstack@SSH-Admin:'/home/openstack/Configuration\ des\ serveurs\ OpenStack/storage/etc'

# Sauvegarde de Ceph
rsync -a /etc/ceph openstack@SSH-Admin:'/home/openstack/Configuration\ des\ serveurs\ OpenStack/storage/etc'

# Sauvegarde de la configuration reseau
rsync -a /etc/network openstack@SSH-Admin:'/home/openstack/Configuration\ des\ serveurs\ OpenStack/storage/etc'

# Sauvegarde du fichier de montage automatique
rsync -a /etc/fstab openstack@SSH-Admin:'/home/openstack/Configuration\ des\ serveurs\ OpenStack/storage/etc'
