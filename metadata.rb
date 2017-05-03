name             'monitoring'
maintainer       'Oregon State University'
maintainer_email 'systems@osuosl.org'
license          'Apache 2.0'
description      'Installs/Configures monitoring'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends          'munin'
depends          'nagios'
depends          'yum'

supports         'centos', '~> 6'
supports         'centos', '~> 7'
supports         'fedora', '20'
supports         'fedora', '21'
