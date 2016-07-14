
windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/MORGANSSO.cer" do
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/MORGANSSO.cer" do
  store_name "ROOT"
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/xclient_egisticsinc_com.pfx" do
  pfx_password "password"
  private_key_acl ["EGISTICS\\FDC-PRD-WEB$"]
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/xclient_egisticsinc_com.pfx" do
  pfx_password "password"
  private_key_acl ["EGISTICS\\FDC-PRD-WEB$"]
  store_name "ROOT"
end