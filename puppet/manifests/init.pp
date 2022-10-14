class { 'apache2':
  content=> lookup('content', undef, first, 'par defaut'),
}
