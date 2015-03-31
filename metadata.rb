name             'monitoring'
maintainer       'Oregon State University'
maintainer_email 'rudy@grigar.net'
license          'Apache 2.0'
description      'Installs/Configures monitoring'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.9'

depends          'base'
depends          'munin'
depends          'nagios'
depends          'yum'
