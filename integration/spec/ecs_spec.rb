require 'awspec'
require 'hcl/checker'

TFVARS = HCL::Checker.parse(File.open('testing.tfvars').read())
ENVVARS = eval(ENV['KITCHEN_KITCHEN_TERRAFORM_OUTPUTS'])

describe ecs_service("#{TFVARS['app_name']}-svc"), cluster: TFVARS['cluster_name'] do
  it { should exist }
  it { should be_active }

  it 'should have no load balancers' do
    load_balancers = subject.load_balancers.map {|load_balancer| load_balancer}

    expect(load_balancers.length).to eq 0
  end

  its(:desired_count) { should eq TFVARS['desired_task_count']}
  its(:running_count) { should eq TFVARS['desired_task_count']}
  its(:launch_type) { should eq TFVARS['launch_type']}
  its(:task_definition) { should eq ENVVARS[:task_definition_arn][:value]}
  its(:status) { should eq 'ACTIVE'}
end

describe ecs_task_definition(ENVVARS[:task_definition_arn][:value]) do
  it { should exist }
  it { should be_active }
  its(:task_role_arn) { should eq TFVARS['task_role_arn']}

  it 'should have the correct volumes' do
    volumes = subject.volumes.map {|volume| volume}

    expect(volumes[0].name).to eq TFVARS['volumes'][0]['name']
    expect(volumes[0].host['source_path']).to eq TFVARS['volumes'][0]['host_path']
  end

  its(:cpu) { should eq TFVARS['cpu']}
  its(:memory) { should eq TFVARS['memory']}
end