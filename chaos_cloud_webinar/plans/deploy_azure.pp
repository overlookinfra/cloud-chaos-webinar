plan bolt_cloud_demo::deploy_azure(
  Integer $howmany
) {
  # TODO: Setup cert signing with pe server.
  $pe_server = get_targets('pe_server')[0]
  $task = run_task(
    'terraform::apply',
    localhost,
    var => {
      howmany   => $howmany,
    },
    dir => './terraform/azure'
  )

  $task.results[0]['stdout'].split('\n').each |$line| {
    if $line =~ "^Apply complete!" {
      return "Terraform: ${line}"
    }
  }
}
