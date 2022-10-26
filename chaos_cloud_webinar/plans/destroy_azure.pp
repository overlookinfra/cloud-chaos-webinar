plan bolt_cloud_demo::destroy_azure(){
  ## PURGE NODES FROM PUPPET
  $pe_server = get_targets('pe_server')
  $nodes = get_targets('azure')
  $nodes.each | $node | {
    out::message("Removing ${node} from Puppet Enterprise.")
    run_command("/opt/puppetlabs/bin/puppet node purge ${node}", $pe_server)
  }

  out::message('Destroying resources via Terraform...')
  $task = run_task('terraform::destroy', localhost, dir => './terraform/azure')
  $task.results[0]['stdout'].split('\n').each |$line| {
    if $line =~ "^Destroy complete!" {
      return "Terraform: ${line}"
    }
  }
}
