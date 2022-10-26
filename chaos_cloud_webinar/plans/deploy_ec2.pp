plan bolt_cloud_demo::deploy_ec2(
  Integer $howmany
){
  # TODO: setup cert signing with pe server.
  $pe_server = get_targets('pe_server')[0]
  $task = run_task('terraform::apply',localhost,
    var => {
      howmany   => $howmany,
      pe_server => 'yourPEserver.IP.us-west-1.compute.amazonaws.com'
    },
    dir => './terraform/aws'
  )
  $task.results[0]['stdout'].split('\n').each |$line| {
    if $line =~ "^Apply complete!" {
      return("Terraform: ${line}")
    }
  }
