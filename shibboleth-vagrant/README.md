# Shibboleth Vagrant

Gets an instance of [Shibboleth](https://shibboleth.net/products/identity-provider.html) up and running using Vagrant and Puppet.

## Getting started

In this directory, run `vagrant up`. It will set up the VM with Shibboleth.

You can check to make sure everything worked by visiting: https://shibboleth.vagrant.dev/idp/status

To further test the functionality you can follow the instructions on http://testshib.org

To use the IDP in your application, point it at https://shibboleth.vagrant.dev/idp/shibboleth

## Configuration

This sets up a default identity provider. The usernames and passwords are in puppet/nodes/shibboleth.pp
