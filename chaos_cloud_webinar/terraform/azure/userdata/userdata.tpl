#!/bin/sh

echo done >> done.txt

if [ ! -d /etc/puppetlabs/puppet ]; then
  mkdir -p /etc/puppetlabs/puppet
fi

cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
extension_requests:
  pp_role: ${pp_role}
  pp_datacenter: ${pp_datacenter}
  pp_environment: ${pp_environment}
YAML

# the next line are necessary when your PE server is hosted in AWS, which always uses the internal DNS for the cert
# these lines inject the names 'puppet' and the internal DNS into the created system's hosts file
# this should be unnecessary if all DNS is handled via your organizational DNS servers

sudo echo "[pe server ID] puppet yourpeserverinternet.ip.us-west-1.compute.internal" >> /etc/hosts

curl -k https://yourpeserverinternet.ip.compute.amazonaws.com:8140/packages/current/install.bash | sudo bash -s agent:certname=${fqdn}
/opt/puppetlabs/bin/puppet agent -t --waitforcert 0 --detailed-exitcodes
