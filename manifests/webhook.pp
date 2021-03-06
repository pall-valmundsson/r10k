# This class creates a github webhoook to allow curl style post-rec scripts
class r10k::webhook(
  $owner = 'root',
  $group = '0',
  $git_server = 'localhost',
) {
  File {
    ensure => file,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { 'webhook_init_script':
    content => template("${module_name}/etc/init.d/webhook.erb"),
    path    => '/etc/init.d/webhook',
    require => Package['sinatra'],
  }
  file { 'webhook_bin':
    content => template("${module_name}/usr/local/bin/webhook.erb"),
    path    => '/usr/local/bin/webhook',
    notify  => Service['webhook'],
  }

  service { 'webhook':
    ensure    => 'running',
    pattern   => '.*ruby.*webhoo[k]',
    hasstatus => false,
  }

  package { 'sinatra':
    ensure   => installed,
    provider => 'pe_gem',
  }
}
