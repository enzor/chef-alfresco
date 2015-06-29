
# Repo configuration
node.default['alfresco']['properties']['alfresco.protocol'] = "https"
node.default['alfresco']['properties']['alfresco.port'] = 443
node.default['alfresco']['properties']['share.protocol'] = "https"
node.default['alfresco']['properties']['share.port'] = 443

node.default['alfresco']['repo_tomcat_instance']['proxy_port'] = 443
node.default['alfresco']['repo_tomcat_instance']['ssl_port'] = 8433

# Share configuration
node.default['alfresco']['share_tomcat_instance']['proxy_port'] = 443
node.default['alfresco']['share_tomcat_instance']['ssl_port'] = 8443

# Solr configuration
if node['alfresco']['enable.solr.ssl']
  node.default['alfresco']['solr_tomcat_instance']['ssl_port'] = 8453
  node.default['alfresco']['properties']['solr.port.ssl'] = 8453
  node.default['alfresco']['properties']['solr.secureComms'] = "https"
  node.default['alfresco']['solrproperties']['alfresco.secureComms'] = "https"
  node.default['alfresco']['solrproperties']['alfresco.port.ssl'] = 8433
end
