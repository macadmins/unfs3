User-space NFS Server (UNFS3)
=====================

This image implements the *User-space NFSv3 Server* (http://unfs3.sourceforge.net/)

The official description: _"UNFS3 is a user-space implementation of the NFSv3 server specification. It provides a daemon for the MOUNT and NFS protocols, which are used by NFS clients for accessing files on the server."_

A number of Docker host platforms don't offer a kernel-space NFS daemon such as Tinycore or CoreOS, limiting their ability to successfully run other Docker NFS server images such as https://github.com/cpuguy83/docker-nfs-server or https://github.com/pandrew/docker-nfs-server.

Although these platforms can be custom-built with NFS daemon support, implementing a user-space NFS daemon circumvents the need to go through the non-trivial process of configuring and building such an OS image.

Usage
-----
The current UNFS3 implementation is fairly simple and uses a statically linked _/etc/exports_ file. To add your own exports entries you must use a volume mount to link to an _exports_ file on the host with _**-v /path/on/host/exports:/etc/exports**_ - this way a new export entry can easily be made on the host. This image will be updated at a later time to allow shares to be defined at docker runtime, as is common with aforementioned NFS server images. More advanced configuration through **etcd** is also in the works.

**Getting started**

Prepare an _exports_ file on the host:

`
$ echo "/to/share (ro|rw)" >> /host/path/exports
`

Run Docker and mount any number of host-based volumes or volumes from other containers at the guest path(s) specified in the exports file:

`
$ docker run --rm -d -p --privileged -p 111:111/udp -p 111:111/tcp -p 2049:2049/udp -p 2049:2049/tcp (-v /host/path:/to/share | --volumes-from <container>) -v /host/path/exports:/etc/exports --name unfs3 macadmins/unfs3
`

**Adding an exports entry**

`$ echo "/some/other/path (ro|rw)" >> /host/path/exports`

`$ docker stop unfs3 && docker start unfs3`

Or when using CoreOS:

`$ systemctl restart unfs3`
