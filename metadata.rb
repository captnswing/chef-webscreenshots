name 'webscreenshots'
maintainer 'Frank Hoffsummer'
maintainer_email 'frank.hoffsummer@gmail.com'
license 'All rights reserved'
description 'Installs and configures webscreenshots application'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.4'

depends 'runit'
depends 'python'
depends 'postgresql'
depends 'nginx'

supports 'scientific', '>= 6.0'
supports 'ubuntu', '>= 10.4'
