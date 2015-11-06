haproxy_cfg_source = node['haproxy']['conf_template_source']
haproxy_cfg_cookbook = node['haproxy']['conf_cookbook']
enable_rsyslog_server = node['haproxy']['enable_rsyslog_server']
rsyslog_bind = node['haproxy']['rsyslog_bind']

include_recipe 'alfresco::_certs'
include_recipe 'alfresco::_errorpages'

# Sets ec2 tags (must be before haproxy.cfg configuration)
include_recipe 'alfresco::haproxy-ec2-discovery' # ~FC014

if node['haproxy']['logging_json_enabled']
node.default['haproxy']['logformat'] = "log-format  {\"type\":\"haproxy\",\"timestamp\":%Ts.%ms,\"actconn\":%ac,\"feconn\":%fc,\"beconn\":%bc,\"backend_queue\":%bq,\"srv_conn\":%sc,\"retry\":%rc,\"tq\":%Tq,\"tw\":%Tw,\"tc\":%Tc,\"tr\":%Tr,\"tt\":%Tt,\"tsc\":\"%tsc\",\"client_addr\":\"%ci:%cp\",\"front_addr\":\"%fi:%fp\",\"front_transport\":\"%ft\",\"ssl_version\":\"%sslv\",\"ssl_cipher\":\"%sslc\",\"http_status\":%ST,\"http_req\":\"%r\",\"back_name\":\"%b\",\"back_server\":\"%s\",\"req_header_cap\":\"%hr\",\"resp_header_cap\":\"%hs\",\"bytes_uploaded\":%U,\"bytes_read\":%B,\"unique_id\":\"%ID\"} "
else
  node.default['haproxy']['logformat'] = "#-"
end

include_recipe 'haproxy::default'

# Set haproxy.cfg custom template
# TODO - fix it upstream and send PR
r = resources(template: "#{node['haproxy']['conf_dir']}/haproxy.cfg")
r.source(haproxy_cfg_source)
r.cookbook(haproxy_cfg_cookbook)

# Haproxy rsyslog configuration
directory "/var/log/haproxy" do
  action :create
  owner "haproxy"
  group "haproxy"
end
template "/etc/rsyslog.d/haproxy.conf" do
  source "rsyslog/haproxy.conf.erb"
end

# TODO - this block can be contributed to a lib cookbook, somewhere
# Make sure Rsyslog is configured to receive Haproxy logs
if enable_rsyslog_server and File.exist?('/etc/rsyslog.conf')
  lines_to_append = [
    ["$ModLoad imudp",nil],
    ["$UDPServerAddress #{rsyslog_bind}","$UDPServerAddress"],
    ["$UDPServerRun 514","$UDPServerRun"]
  ]

  lines_to_append.each do |line|
    new_line = line[0]
    line_match = line[1]

    if line_match == nil
      line_match = new_line
    end
    replace_or_add "rsyslog-conf-#{line}" do
      path "/etc/rsyslog.conf"
      pattern line_match
      line new_line
      notifies :restart, 'service[rsyslog]', :delayed
    end
  end

  service 'rsyslog' do
    action :nothing
  end
end

# include_recipe 'rsyslog::server'

# Disable default server configuration, we just need haproxy
# r = resources(template: "#{node['rsyslog']['config_prefix']}/rsyslog.d/35-server-per-host.conf")
# r.action(:nothing)
