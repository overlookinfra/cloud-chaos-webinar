plan bolt_cloud_demo::destroy(
  Enum['aws','azure','all'] $cloud
){
  out::message('Destroying everything you worked so hard to build...')

  case $cloud {
    default: { fail_plan("I'm sorry, Dave. I can't do that.") }
    'aws': {
      out::message('Destroying EC2 instances...')
      run_plan('bolt_cloud_demo::destroy_ec2')
    }
    'azure': {
      out::message('Destroying Azure instances...')
      run_plan('bolt_cloud_demo::destroy_azure')
    }

    'all': {
      out::message('Destroying EC2 instances...')
      run_plan('bolt_cloud_demo::destroy_ec2')
      out::message('Destroying Azure instances...')
      run_plan('bolt_cloud_demo::destroy_azure')
    }
  }
}
