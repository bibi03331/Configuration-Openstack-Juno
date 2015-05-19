require 'bundler/setup'
require 'json'
require 'yaml'
require 'filesize'

# common config file
dashing_config = './config.yaml'
config = YAML.load_file(dashing_config)
environments = config['ceph']

last = {}
config['pools'].keys.each do |name|
    last[name] = 0
end

SCHEDULER.every '5s' do

  cmd_get_status = "ssh " + environments['user_name'] + '@' + environments['host'] + " timeout 3 ceph df -f json"
  result = `#{cmd_get_status}`

  # update total storage widget
  storage = JSON.parse(result)
  used = storage['stats']['total_used'].to_i
  total = storage['stats']['total_space'].to_i
  send_event('storage',
    {
      value: Filesize.from("#{used} KB").pretty.split(' ').first.to_f,
      min: 0,
      max: Filesize.from("#{total} KB").pretty.split(' ').first.to_f,
      moreinfo: Filesize.from("#{used} KB").pretty + " out of " + Filesize.from("#{total} KB").pretty
    }
  )

  # update each of the config pools widgets
  config['pools'].keys.each_with_index do |poolname, index|
    for pool in storage['pools'] do
      if pool['name'] == poolname
        send_event("pool#{index}", { current: pool['stats']['bytes_used'], last: last[pool['name']],
                                     title: config['pools'][poolname]['display_name'] } )
        last[pool['name']] = pool['stats']['bytes_used']
      end
    end
  end

end
