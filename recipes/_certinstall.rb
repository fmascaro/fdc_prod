
windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/MORGANSSO.cer" do
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/MORGANSSO.cer" do
  store_name "ROOT"
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/MORGANROOT.cer" do
  store_name "ROOT"
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/MORGANINT.cer" do
  store_name "ROOT"
end


windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/DIGICERTROOT.cer" do
  store_name "ROOT"
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/DIGICERTINT.cer" do
  store_name "CA"
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/xclient_egisticsinc_com.pfx" do
  private_key_acl ["EGISTICS\\FDC-PRD-WEB$"]
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/xclient_egisticsinc_com.pfx" do
  private_key_acl ["EGISTICS\\FDC-PRD-WEB$"]
  store_name "ROOT"
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/TISSSO_COMP.pfx" do
  private_key_acl ["EGISTICS\\FDC-PRD-WEB$"]
end

windows_certificate "//DP-ESL-EFS-01/GOLDREP/SSLCERTIFICATES/TISSSO_COMP.pfx" do
  store_name "ROOT"
  private_key_acl ["EGISTICS\\FDC-PRD-WEB$"]
end
