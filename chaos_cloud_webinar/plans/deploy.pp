plan bolt_cloud_demo::deploy(
  Enum['aws','azure','gcloud','all'] $cloud,
  Integer $howmany,
  # TargetSpec $pe_server,
) {
  $pe_server=get_target('pe_server')
  case $cloud {
    default: { fail_plan('No cloud selected.') }
    aws: {
      out::message('Provisioning AWS instances...')
      $plan = run_plan('bolt_cloud_demo::deploy_ec2',
      howmany=>$howmany)
      out::message($plan)
    }
    azure: {
      out::message('Provisioning Azure virtual machines...')
      $plan = run_plan('bolt_cloud_demo::deploy_azure', howmany=>$howmany)
      out::message($plan)
    }
    # gcloud: {
    #   out::message('Provisioning Google Compute instances...')
    #   run_plan('bolt_cloud_demo::deploy_gcloud', howmany=>$howmany)
    # }
    all: {
      out::message('Provisioning all the clouds.')
      out::message('Provisioning AWS instances...')
      $aws_plan = run_plan('bolt_cloud_demo::deploy_ec2', howmany=>$howmany)
      out::message($aws_plan)

      out::message('Provisioning Azure virtual machines...')
      $azure_plan = run_plan('bolt_cloud_demo::deploy_azure', howmany=>$howmany)
      out::message($azure_plan)
      # out::message('Provisioning Google Compute instances...')
      # run_plan('bolt_cloud_demo::deploy_gcloud', howmany=>$howmany)
    }
  }
  $resp = "Plan complete. Check https://${pe_server} in a few minutes..."
  return $resp
}
