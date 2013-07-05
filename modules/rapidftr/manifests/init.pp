class rapidftr {
  include apt

  $user = 'vagrant'
  $group = $user
  $project = 'rapidftr'
  $home = "/home/$user"
  $root = "$home/$project"
  $couchdb_ppa = 'ppa:nilya/couchdb-1.3'
  $core_packages = [
    'libxml2-dev',
    'libxslt1-dev',
    'build-essential',
    'git',
    'openjdk-7-jdk',
    'imagemagick',
    'openssh-server',
    'zlib1g-dev'
  ]
  $ruby_version = '1.9.3-p392'
  $ruby_build_name = "$ruby_version-railsexpress"
  $cd_project_root_command = "cd $root"

  Exec { path => [
      "$home/.rbenv/shims",
      "$home/bin",
      '/usr/local/sbin',
      '/usr/local/bin',
      '/usr/sbin',
      '/usr/bin',
      '/sbin',
      '/bin'
    ]
  }

  apt::ppa { $couchdb_ppa: }

  package { 'couchdb':
    ensure => present,
    require => Apt::Ppa[$couchdb_ppa]
  }

  package { $core_packages:
    ensure => present
  }

  rbenv::install { $user: }

  rbenv::compile { $ruby_build_name:
    ruby => $ruby_version,
    user => $user,
    source => "puppet:///modules/rapidftr/$ruby_build_name"
  }

  vcsrepo { $root:
    user => $user,
    ensure => present,
    provider => git,
    source => 'https://github.com/rapidftr/RapidFTR.git'
  }

  exec { 'bundle install':
    unless => 'bundle check',
    user => $user,
    cwd => $root,
    timeout => 1800,
    require => [ Rbenv::Compile[$ruby_build_name], Vcsrepo[$root] ]
  }

  exec { 'rbenv rehash':
    user => $user,
    cwd => $root,
    subscribe => Exec['bundle install'],
    refreshonly => true
  }

  exec { "echo '$cd_project_root_command' >> .bashrc":
    unless => "grep -q '$cd_project_root_command' .bashrc",
    user => $user,
    cwd => $home
  }
}
