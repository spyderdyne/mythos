#Create Mythos scale images for server and client and configure them.
#Please set the 'replace_ip_address variable to the address you will use for your
#server node before you do anything else.  Refer to the $MYHTOS_HOME/images/set-environemnt.sh
#script for details.
class medusa_serpent {

  $medusa_master_ip           = 'replace_ip_address' #You need to identify and set the globally reachable IP address of your Medusa server prior to generating images.

  $phoronix_wsgi_port         = '8089' #Phoronix web socket port
  $phoronix_master_port       = '8088' #Phoronix Server Communicaiton Port
  $phoronix_www_port          = '8081' #Phoronix Web Portal
  $medusa_master_port         = '8080' #Medusa Web Portal for Script Hosting
  $medusa_slave_port          = '80'   #Medusa Client web site for testing
  $medusa_egress_gateway      = 'replace_gateway_address' #Cloud egress internal IP address
  $medusa_private_cidr        = 'replace_private_cidr' #The CIDR of the private (overlay) subnet for your tenants/accounts

  $service_password           = 'Thewheelsonthebusgoroundandround2015!'

  exec { 'apt-get update':
    path => '/usr/bin',
  }
  package { 'apache2':
    ensure  => present,
    require => Exec['apt-get update'],
  }
  service { 'apache2':
    ensure  => 'running',
    require => Package['apache2'],
  }
  #package { 'inotify-tools':
  #  ensure => present,
  #  require => Exec['apt-get update'],
  #}
  package { 'nmap':
    ensure => present,
    require => Exec['apt-get update'],
  }
  package { 'smokeping':
    ensure  => present,
    require => Exec['apt-get update'],
  }
  service { 'smokeping':
    ensure  => 'running',
    require => Package['smokeping'],
  }
  file { '/etc/apache2/sites-available/000-default.conf':
    ensure  => file,
    content => template('medusa_serpent/000-default.erb'),
    require => Package['apache2'],
    notify  => Service['apache2'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure  => 'link',
    target  => '/etc/apache2/sites-available/000-default.conf',
    require => File['/etc/apache2/sites-available/000-default.conf'],
    notify  => Service['apache2'],
  }
  file { '/var/www/html/index.html':
    ensure  => present,
    require => Package['apache2'],
    notify  => Service['apache2'],
    content => template('medusa_serpent/medusa.erb'),
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  }
  #file { '/etc/smokeping/config.d/Alerts':
  #  ensure  => present,
  #  require => Package['smokeping'],
  #  notify  => Service['smokeping'],
  #  content => template('medusa_serpent/smokeping-alerts.erb'),
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #}
  #file { '/etc/smokeping/config.d/Database':
  #  ensure  => present,
  #  require => Package['smokeping'],
  #  notify  => Service['smokeping'],
  #  content => template('medusa_serpent/smokeping-database.erb'),
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #}
  #file { '/etc/smokeping/config.d/General':
  #  ensure  => present,
  #  require => Package['smokeping'],
  #  notify  => Service['smokeping'],
  #  content => template('medusa_serpent/smokeping-general.erb'),
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #}
  #file { '/etc/smokeping/config.d/Probes':
  #  ensure  => present,
  #  require => Package['smokeping'],
  #  notify  => Service['smokeping'],
  #  content => template('medusa_serpent/smokeping-probes.erb'),
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #}
  #file { '/etc/smokeping/config.d/Targets':
  #  ensure  => present,
  #  require => Package['smokeping'],
  #  notify  => Service['smokeping'],
  #  content => template('medusa_serpent/smokeping-targets.erb'),
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #}
  file { '/opt/trunk/':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    require => Package['bzr'],
  }
  package { 'phoronix-test-suite':
    ensure  => present,
    require => Exec['apt-get update'],
  }
  package { 'siege':
    ensure  => present,
    require => Exec['apt-get update'],
  }
  package { 'bzr':
    ensure  => present,
    require => Package['siege'],
  }
  group { 'medusa':
    ensure  => present,
  }
  user { 'medusa':
    ensure     => present,
    gid        => 'medusa',
    shell      => '/bin/bash',
    home       => '/opt/trunk/mythos/medusa',
    managehome => 'true',
    require    => Exec['bzr-pull-repo'],
  }
  file { '/root/.ssh/id_rsa_medusa.pem':
    ensure  => present,
    require => User['medusa'],
    source  => 'puppet:///modules/medusa_serpent/id_rsa_medusa.pem',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }
  file { '/root/.ssh/config':
    ensure  => file,
    require => User['medusa'],
    content => template('medusa_serpent/root-ssh-config.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }
  exec { 'fetch-phoronix-stable':
    command => 'wget --timestamping http://phoronix-test-suite.com/releases/repo/pts.debian/files/phoronix-test-suite_5.8.0_all.deb',
    tries   => '5',
    path    => '/usr/bin',
    cwd     => '/opt',
    require => Exec['apt-get update'],
  }
  file { '/opt/phoronix-test-suite_5.8.0_all.deb':
    ensure => present,
    require => Exec['fetch-phoronix-stable'],
  }
  #exec { 'install-smokeping-deps':
  #  command => 'apt-get install -y fping libauthen-radius-perl libnet-ldap-perl libnet-dns-perl libio-socket-ssl-perl libnet-telnet-perl libsocket6-perl libio-socket-inet6-perl',
  #  path    => '/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/sbin',
  #  require => Package['smokeping'],
  #  notify  => Service['smokeping'],
  #}
  #May not be needed with the new version...
  exec { 'install-phoronix-deps':
    command => 'apt-get install -y libgd3 libxpm4 php5-cli php5-common php5-gd php5-json php5-readline php5-json',
    path    => '/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/sbin',
    require => File['/opt/phoronix-test-suite_5.8.0_all.deb'],
  }
  exec { 'install-phoronix':
    command => 'dpkg -i phoronix-test-suite_5.8.0_all.deb',
    path    => '/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/sbin',
    require => Exec['install-phoronix-deps'],
    cwd     => '/opt',
  }
  exec { 'bzr-pull-repo':
    command => 'bzr checkout lp:~openstack-tailgate/openstack-tailgate/trunk /opt/trunk',
    tries   => '5',
    path    => '/usr/bin/',
    require => File['/opt/trunk/'],
    returns => ['0','3'],
  }
  exec { 'phoronix-first-run':
    command => 'echo "y n n" | phoronix-test-suite',
    path    => '/bin/:/usr/bin/',
    require => Exec['install-phoronix'],
  }
  exec { 'phoronix-clean-clients':
    command => 'rm -rf /var/lib/phoronix-test-suite/core.pt2so',
    path    => '/bin/',
    require => Exec['phoronix-first-run'],
  }
  file { '/var/lib/phoronix-test-suite/user-config.xml':
    ensure  => file,
    content => template('medusa_serpent/slave-user-config.erb'),
    require => Exec['phoronix-first-run'],
  }
  exec { 'start-phoronix-clients':
    command => 'phoronix-test-suite phoromatic.connect',
    path    => '/usr/bin/',
    require => Exec['phoronix-first-run'],
  }
  file { '/opt/trunk/mythos/medusa/master-commander.sh':
    ensure  => file,
    require => Exec['bzr-pull-repo'],
    content => template('medusa_serpent/master-commander.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
  file { '/etc/init.d/mythos-client':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('medusa_serpent/mythos-client.erb'),
    require => Exec['install-phoronix'],
  }
  file { '/etc/init/mythos-client.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('medusa_serpent/mythos-client.conf.erb'),
    require => Exec['install-phoronix'],
  }
  file { '/root/.siegerc':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('medusa_serpent/siegerc.erb'),
    require => Package['siege'],
  }
  cron { 'update_cron':
    ensure  => 'present',
    command => '/opt/trunk/mythos/medusa/master-commander.sh',
    user    => 'root',
    hour    => '*',
    minute  => '*/10',
    require => File['/opt/trunk/mythos/medusa/master-commander.sh'],
  }
  #cron { 'update_cron': #<<< Can this be removed now?
  #  ensure  => 'present',
  #  command => '/opt/trunk/mythos/medusa/update-status.sh',
  #  user    => 'root',
  #  hour    => '*',
  #  minute  => '*/30',
  #  require => File['/opt/trunk/mythos/medusa/update-status.sh'],
  #}
  #cron { 'reporting_update':
  #  ensure  => 'present',
  #  command => '/opt/trunk/mythos/medusa/smokeping/update_outage_report.sh',
  #  user    => 'root',
  #  hour    => '*',
  #  minute  => '*/30',
  #  require => File['/opt/trunk/mythos/medusa/update-status.sh'],
  #}
}