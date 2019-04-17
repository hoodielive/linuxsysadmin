user { 'jon':
  ensure     => present,
  uid        => '1001',
  gid        => '1000',
  comment    => 'Jon Doe',
  managehome => true,
}

# this means
1. A user named Jon Doe.
2. Should be 'present'.
3. A home directory for the user must be created.

# this 'describes' the desire and leaves it up to puppet to figure out how to do it.
# notice there is no telling puppet 'how' to acheive this (imperative), just the description on 'how' it should be done.
