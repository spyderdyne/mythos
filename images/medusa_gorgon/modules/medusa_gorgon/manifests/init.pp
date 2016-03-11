#Create Mythos scale images for server and client and configure them.
#Please set the 'replace_ip_address variable to the address you will use for your
#server node before you do anything else.  Refer to the $MYHTOS_HOME/images/set-environemnt.sh
#script for details.
class medusa_gorgon {

  $medusa_master_ip             = 'replace_ip_address'                    # Globally reachable IP address of Gorgon server
  $phoronix_wsgi_port           = '8089'                                  # Phoronix web socket port
  $phoronix_master_port         = '8088'                                  # Phoronix Server Communicaiton Port
  $phoronix_user_key            = 'TBD'                                   # Phoromatic User Key
  $phoronix_www_port            = '8081'                                  # Not sure what this does...
  $medusa_master_port           = '80'                                    # Medusa Web Portal for Script Hosting
  $medusa_results_port          = '88'                                    # Secure Siege Results Page on Gorgon Server Node
  $medusa_results_user_name     = 'replace_results_user_name'             # Medusa View-Only User
  $medusa_results_admin_name    = 'replace_results_admin_name'            # Medusa Admin User
  $medusa_results_user_pass     = 'replace_results_user_pass'             # Medusa User Password
  $medusa_results_admin_pass    = 'replace_results_admin_pass'            # Medusa Admin Password
  $medusa_slave_port            = '80'                                    # Medusa Client web site for testing
  $medusa_private_CIDR          = '192.168.0.0/24'                        # Subnet for client neighbor discovery
  $service_password             = 'Thewheelsonthebusgoroundandround2015!' # Phoronix master password

  exec { 'apt-get update':
    path => '/usr/bin',
  }
  package { 'apache2':
    ensure  => present,
    require => Exec['apt-get update'],
  }
  package { 'apache2-utils':
    ensure  => present,
    require => Package['apache2'],
  }
  service { 'apache2':
    ensure  => running,
    require => Package['apache2'],
  }
  file { '/etc/apache2/sites-available/000-default.conf':
    ensure  => file,
    content => template('medusa_gorgon/000-default.erb'),
    require => Package['apache2-utils'],
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
  file { '/etc/apache2/sites-available/000-results.conf':
    ensure  => file,
    content => template('medusa_gorgon/000-results.erb'),
    require => Package['apache2-utils'],
    notify  => Service['apache2'],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  file { '/etc/apache2/sites-enabled/000-results.conf':
    ensure  => 'link',
    target  => '/etc/apache2/sites-available/000-results.conf',
    require => File['/etc/apache2/sites-available/000-results.conf'],
    notify  => Service['apache2'],
  }
  file { '/var/www/html/medusa':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['apache2'],
  }
  file { '/opt/trunk/':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['bzr'],
  }
  file { '/var/www/html/medusa/index.html':
    ensure  => present,
    require => File['/var/www/html/medusa'],
    notify  => Service['apache2'],
    content => template('medusa_gorgon/medusa.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  package { 'siege':
    ensure  => present,
    require => Exec['apt-get update'],
  }
  package { 'pssh':
    ensure  => present,
    require => Exec['apt-get update'],
  }
  package { 'bzr':
    ensure  => present,
    require => Exec['apt-get update'],
  }
  package { 'libgd-graph-perl':
  ensure  => present,
  require => Exec['apt-get update'],
}
  package { 'libchart-perl':
    ensure  => present,
    require => Package['libgd-graph-perl'],
  }
  group { 'medusa':
    ensure  => present,
    require => Exec['bzr-pull-repo']
  }
  user { 'medusa':
    ensure     => present,
    gid        => 'medusa',
    shell      => '/bin/bash',
    home       => '/opt/trunk/mythos/medusa',
    managehome => 'true',
    require    => Exec['bzr-pull-repo'],
  }
  file { '/root/.ssh/id_rsa_medusa':
    ensure  => present,
    mode    => '600',
   require => User['medusa'],
    source  => 'puppet:///modules/medusa_gorgon/id_rsa_medusa',
  }
  file { '/root/.ssh/id_rsa_medusa.pub':
    ensure  => present,
    mode    => '600',
    require => User['medusa'],
    source  => 'puppet:///modules/medusa_gorgon/id_rsa_medusa.pub',
  }
  exec { 'configure-user-auth':
    command => 'echo "$medusa_results_user_pass $medusa_results_user_pass" | htpasswd -c /etc/apache2/.htpasswd $medusa_results_user_name',
    path    => '/usr/bin',
    require => Package['apache2-utils'],
  }
  exec { 'configure-admin-auth':
    command => 'echo "$medusa_results_admin_pass $medusa_results_admin_pass" | htpasswd /etc/apache2/.htpasswd $medusa_results_admin_name',
    path    => '/usr/bin',
    require => Package['apache2-utils'],
  }
  exec { 'configure-auth':
    command => 'cat /root/.ssh/id_rsa_medusa.pub >> /root/.ssh/authorized_keys',
    path    => '/bin',
    require => File['/root/.ssh/id_rsa_medusa.pub'],
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
  exec { 'install-phoronix-deps':
    command => 'apt-get install -y libgd3 libxpm4 php5-cli php5-common php5-gd php5-json php5-readline php5-json php5-sqlite',
    require => File['/opt/phoronix-test-suite_5.8.0_all.deb'],
    path    => '/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/sbin',
  }
  exec { 'install-phoronix':
    command => 'dpkg -i phoronix-test-suite_5.8.0_all.deb',
    path    => '/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/sbin',
    require => Exec['install-phoronix-deps'],
    cwd     => '/opt',
  }
  exec { 'bzr-pull-repo':
    command => 'bzr checkout lp:~openstack-tailgate/openstack-tailgate/trunk /opt/trunk/',
    tries   => '5',
    path    => '/usr/bin/',
    require => File['/opt/trunk/'],
    returns => ['0','3'],
  }
  file { '/var/lib/phoronix-test-suite/user-config.xml':
    ensure  => file,
    content => template('medusa_gorgon/server-user-config.erb'),
    require => Exec['phoronix-first-run'],
  }
  file { '/etc/init.d/mythos-server':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('medusa_gorgon/mythos-server.erb'),
    require => Exec['install-phoronix'],
  }
  file { '/etc/init/mythos-server.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('medusa_gorgon/mythos-server-conf.erb'),
    require => Exec['install-phoronix'],
  }
  exec { 'phoronix-first-run':
    command => 'echo "y n n" | phoronix-test-suite',
    path    => '/bin/:/usr/bin/',
    require => Exec['install-phoronix'],
  }
  exec { 'start-phoronix-server':
    command => 'phoronix-test-suite start-phoromatic-server',
    path    => '/usr/bin/',
    require => File['/var/lib/phoronix-test-suite/user-config.xml'],
    returns => ['0','126'],
  }
  exec { 'install-phoronix-tests':
    command => 'phoronix-test-suite batch-install pts/C-Ray pts/pybench-1.0.0 pts/stream pts/tiobench-1.1.0 pts/network-loopback-1.0.1 pts/fio-1.8.2',
    path    => '/usr/bin/',
    require => Exec['start-phoronix-cache'],
    returns => ['0','126'],
  }
  exec { 'start-phoronix-cache':
    command => 'phoronix-test-suite make-download-cache pts/C-Ray pts/pybench-1.0.0 pts/stream pts/tiobench-1.1.0 pts/network-loopback-1.0.1 pts/fio-1.8.2',
    path    => '/usr/bin/',
    require => Exec['start-phoronix-server'],
    returns => ['0','126'],
  }
  file { '/var/www/html/medusa/scripts/':
    ensure  => 'link',
    target  => '/opt/trunk/mythos/medusa/remote-scripts/',
    notify  => Service['apache2'],
    require => Exec['bzr-pull-repo'],
  }
  file { '/var/www/html/reporting/':
    ensure  => 'link',
    target  => '/opt/trunk/mythos/seshat/',
    notify  => Service['apache2'],
    require => Exec['bzr-pull-repo'],
  }
  file { '.htaccess':
    ensure  => present,
    path    => ['/var/www/html/reporting/reports/generator/','/var/www/html/reporting/settings'],
    content => template('medusa_gorgon/htaccess.erb'),
    notify  => Service['apache2'],
    require => Exec[''],
  }
  file { '/opt/trunk/mythos/medusa/remote-scripts/.client-init.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    content => template('medusa_gorgon/.client-init.erb'),
    require => File['/var/www/html/medusa/scripts/'],
  }
  file { '/opt/trunk/mythos/medusa/remote-scripts/.client-discovery.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    content => template('medusa_gorgon/.client-discovery.erb'),
    require => File['/var/www/html/medusa/scripts/'],
  }
  file { '/opt/trunk/mythos/medusa/remote-scripts/.bombardment0.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    content => template('medusa_gorgon/.bombardment0.erb'),
    require => File['/var/www/html/medusa/scripts/'],
  }
  file { '/opt/trunk/mythos/medusa/awaken_the_gorgon.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    content => template('medusa_gorgon/awaken_the_gorgon.erb'),
    require => File['/var/www/html/medusa/scripts/'],
  }
  file { '/opt/trunk/mythos/medusa/remote-scripts/.phoronix-connect.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    content => template('medusa_gorgon/.phoronix-connect.erb.erb'),
    require => File['/var/www/html/medusa/scripts/'],
  }
  file { '/opt/trunk/mythos/medusa/remote-scripts/.nuclear-option.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '755',
    content => template('medusa_gorgon/.nuclear-option.erb'),
    require => File['/var/www/html/medusa/scripts/'],
  }
}