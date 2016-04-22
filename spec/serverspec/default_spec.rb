require 'spec_helper'
require 'serverspec'

package = 'hbase'
service = 'hbase'
config  = '/etc/hbase/hbase.conf'
user    = 'hbase'
group   = 'hbase'
ports   = [ 2181 ]
log_dir = '/var/log/hbase'
db_dir  = '/var/lib/hbase'
config_dir = '/etc/hbase'
env_config = '/etc/hbase/hbase-env.sh'

case os[:family]
when 'freebsd'
  config_dir = '/usr/local/etc/hbase'
  config = '/usr/local/etc/hbase/hbase-site.xml'
  env_config = '/usr/local/etc/hbase/hbase-env.sh'
  db_dir = '/var/db/hbase'
  service = 'hbase_master'
end

regionservers_file = "#{config_dir}/regionservers"

describe package(package) do
  it { should be_installed }
end 

describe file(env_config) do
  it { should be_file }
  its(:content) { should match Regexp.escape(". #{config_dir}/hbase-env-dist.sh") }
  its(:content) { should match Regexp.escape('export HBASE_OPTS="-XX:+UseConcMarkSweepGC"') }
  its(:content) { should match Regexp.escape('export HBASE_MASTER_OPTS="$HBASE_MASTER_OPTS -XX:PermSize=128m -XX:MaxPermSize=128m"') }
  its(:content) { should match Regexp.escape('export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS -XX:PermSize=128m -XX:MaxPermSize=128m"') }
  its(:content) { should match Regexp.escape('export HBASE_MANAGES_ZK=false') }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape('<name>hbase.rootdir</name>') }
  its(:content) { should match Regexp.escape('<value>file:///var/db/hbase</value>') }
  its(:content) { should match Regexp.escape('<name>hbase.zookeeper.property.dataDir</name>') }
  its(:content) { should match Regexp.escape('<value>/var/db/zookeeper</value>') }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(regionservers_file) do
  it { should be_file }
  its(:content) { should match /127\.0\.0\.1/ }
end

#case os[:family]
#when 'freebsd'
#  describe file('/etc/rc.conf.d/hbase') do
#    it { should be_file }
#  end
#end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
