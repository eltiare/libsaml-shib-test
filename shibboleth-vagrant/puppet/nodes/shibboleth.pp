node 'shibboleth.vagrant.dev' {
  # a few support packages
  package { [ 'vim-nox', 'curl' ]: ensure => installed }

  # Services to be configured in the IdP
  #   key   - short name for service (used for config file names etc)
  #   value - URL where IdP can fetch metadata for said service
  $service_providers = {
    'testshib' => 'http://www.testshib.org/metadata/testshib-providers.xml',
    'test-dev' => 'http://lvh.me:3000/saml/meta.xml'
    #'my-awesome-project' => 'http://my-awesome-project.dev/path/to/saml_meta_data'
  }

  # Users to be configured in the IdP (via tomcat container-based auth)
  #   key   - username
  #   value - password
  $users = {
    'shibadmin' => 'shibshib',
    'shibuser'  => 'shibshib',
    'anotheruser' => 'shibshib'
  }

  class { 'shibboleth':
    service_providers => $service_providers,
    users             => $users
  }
}
