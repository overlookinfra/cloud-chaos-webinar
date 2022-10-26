plan bolt_cloud_demo::destroy_ec2(){
  ## PURGE NODES FROM PUPPET
  $pe_server = get_targets('pe_server')[0]

  $nodes = get_targets('aws')
  $nodes.each | $node | {
    out::message("Removing ${node} from Puppet Enterprise.")
    run_command("/opt/puppetlabs/bin/puppet node purge ${node}", $pe_server)
  }
  ## TERRAFORM DESTROY
  out::message('Destroying resources via Terraform...')
  $task = run_task('terraform::destroy', localhost, dir => './terraform/aws')
  $task.results[0]['stdout'].split('\n').each |$line| {
    if $line =~ "^Destroy complete!" {
      return "Terraform: ${line}"
    }
  }
}
