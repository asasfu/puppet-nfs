# Shamefully stolen from https://github.com/frimik/puppet-nfs
# refactored a bit

class nfs::client::fedora::service {

  Service {
    require => Class['::nfs::client::fedora::configure']
  }

  if $nfs::client::fedora::nfs_v4 == true {
    $nfs4_services_ensure = 'running'
  } else {
    $nfs4_services_ensure = 'stopped'
  }

  if $nfs::client::fedora::nfs_v4_kerberized == true {
    $nfs4_kerberized_services_ensure = 'running'
  } else {
    $nfs4_kerberized_services_ensure = 'stopped'
  }

  if !defined(Service["nfs-secure"]) {
    service { 'nfs-secure': 
      provider  => 'systemd',
      ensure    => $nfs4_kerberized_services_ensure,
      enable    => $nfs::client::fedora::nfs_v4_kerberized,
      hasstatus => true,
    }
  }
  if $::operatingsystemmajrelease <= 21 {    
    if !defined(Service["nfs-idmap"]) {
      service { 'nfs-idmap':
        provider  => 'systemd',
        ensure    => $nfs4_services_ensure,
        enable    => $nfs::client::fedora::nfs_v4,
        hasstatus => true,
        subscribe => File[ '/etc/idmapd.conf', '/etc/sysconfig/nfs' ]
      }
    }
  }

  
#  if !defined(Service['nfs-server']) {
#    service { 'nfs-server':
#      provider  => 'systemd',
#      name      => 'nfs-server',
#      ensure    => running,
#      enable    => true,
#      hasstatus => true,
#    }    
#  }

  service {'nfs-lock':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    require    => Package["nfs-utils"]
  }

  service {"rpcbind":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => [Package["rpcbind"], Package["nfs-utils"]],
  }
}
