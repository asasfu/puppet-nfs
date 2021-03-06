class nfs::server::rhel::service {

#  if $nfs::server::rhel::nfs_v4 == true {
#    $nfs_v4_services_ensure = 'running'
#  } else {
#    $nfs_v4_services_ensure = 'stopped'
#  }

  case $::operatingsystem {
    centos, rhel: {
      if !defined(Service["$nfs::client::rhel::service_nfs"]) {
        service { "$nfs::server::rhel::service_nfs":
          ensure     => running,
          enable     => true,
          hasrestart => true,
          hasstatus  => true,
          restart    => $nfs::server::rhel::service_nfs_restart_cmd,
          require    => Package["nfs-utils"],
          subscribe  => [ Concat['/etc/exports'], File['/etc/idmapd.conf'], File['/etc/sysconfig/nfs'] ],
        }
      }
      else {
        Service<| title == "$nfs::server::rhel::service_nfs" |> {
          ensure     => running,
          enable     => true,
          hasrestart => true,
          hasstatus  => true,
          restart    => $nfs::server::rhel::service_nfs_restart_cmd,
          require    => Package["nfs-utils"],
          subscribe  => [ Concat['/etc/exports'], File['/etc/idmapd.conf'], File['/etc/sysconfig/nfs'] ],
        }
      }
    }
#      fedora: {
#        service { "$nfs::client::rhel::service_nfs":
#          provider   => 'systemd',
#          name       => 'nfs.service',
#          ensure     => running,
#          enable     => true,
#          hasrestart => true,
#          hasstatus  => true,
#          require    => Package["nfs-utils"],
#          subscribe  => [ Concat['/etc/exports'], File['/etc/idmapd.conf'], File['/etc/sysconfig/nfs'] ],
#        }
#      }
  }
}
