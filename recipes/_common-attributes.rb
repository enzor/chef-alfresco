# Alfresco dir root (used in _alfrescoproperties-attributes.rb and below)
node.default['alfresco']['properties']['dir.root'] = "#{node['alfresco']['home']}/alf_data"
node.default['alfresco']['properties']['dir.keystore'] = "#{node['alfresco']['properties']['dir.root']}/keystore/alfresco/keystore"

# Repo config
node.default['alfresco']['properties']['alfresco.host'] = node['alfresco']['default_hostname']
node.default['alfresco']['properties']['alfresco.port.ssl'] = node['alfresco']['default_portssl']
node.default['alfresco']['properties']['alfresco.protocol'] = node['alfresco']['default_protocol']

# Solr Common attributes (used in _tomcat-attributes.rb)
node.default['alfresco']['solrproperties']['data.dir.root'] = "#{node['alfresco']['properties']['dir.root']}/solrhome"
node.default['alfresco']['solrproperties']['alfresco.host'] = node['alfresco']['properties']['alfresco.host']
node.default['alfresco']['solrproperties']['alfresco.port.ssl'] = node['alfresco']['properties']['alfresco.port.ssl']
node.default['alfresco']['solrproperties']['alfresco.baseUrl'] = node['alfresco']['properties']['alfresco.context']
node.default['alfresco']['solrproperties']['alfresco.secureComms'] = node['alfresco']['properties']['solr.secureComms']

if node['alfresco']['enable.ssl']
  node.default['alfresco']['properties']['alfresco.protocol'] = "https"
  node.default['alfresco']['properties']['share.protocol'] = "https"

  if node['alfresco']['components'].include? 'nginx'
    node.default['alfresco']['properties']['alfresco.port'] = 443
    node.default['alfresco']['properties']['share.port'] = 443
    node.default['alfresco']['repo_tomcat_instance']['proxy_port'] = 443
    node.default['alfresco']['share_tomcat_instance']['proxy_port'] = 443
  else
    node.default['alfresco']['properties']['alfresco.port'] = 8433
    node.default['alfresco']['properties']['share.port'] = 8443
    node.default['alfresco']['repo_tomcat_instance']['proxy_port'] = 8433
    node.default['alfresco']['share_tomcat_instance']['proxy_port'] = 8443
  end
  node.default['alfresco']['repo_tomcat_instance']['ssl_port'] = 8433
  node.default['alfresco']['share_tomcat_instance']['ssl_port'] = 8443
end

if node['alfresco']['enable.solr.ssl']
  node.default['alfresco']['solr_tomcat_instance']['ssl_port'] = 8453
  node.default['alfresco']['properties']['solr.port.ssl'] = 8453
  node.default['alfresco']['properties']['solr.secureComms'] = "https"
  node.default['alfresco']['solrproperties']['alfresco.secureComms'] = "https"
  node.default['alfresco']['solrproperties']['alfresco.port.ssl'] = 8433
end
