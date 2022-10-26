#!/bin/sh

if [ ! -d /etc/puppetlabs/puppet ]; then
  mkdir -p /etc/puppetlabs/puppet
fi

cat > /etc/puppetlabs/puppet/csr_attributes.yaml << YAML
extension_requests:
  pp_role: ${pp_role}
  pp_datacenter: ${pp_datacenter}
  pp_environment: ${pp_environment}
YAML

curl -k https://yourpeserver.us-west-1.compute.amazonaws.com:8140/packages/current/install.bash | bash -s agent:certname=`curl http://169.254.169.254/latest/meta-data/public-hostname`
/opt/puppetlabs/bin/puppet config set certname `curl http://169.254.169.254/latest/meta-data/public-hostname`
/opt/puppetlabs/bin/puppet config set yourpeserver.ip.us-west-1.compute.amazonaws.com
/opt/puppetlabs/bin/puppet agent -t --waitforcert 0 --detailed-exitcodes
