#### FDC Val Engine (WS-PRD-FDC-WSVAL-E1)

*@admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_Admin3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_Admin3g;Trusted_Connection=True

*@config_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_Admin3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_Admin3g;Trusted_Connection=True

*@test_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_Admin3G;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_Admin3G;Trusted_Connection=True

*@DR_admin_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

---

### FDC Web Site (WW-PRD-FDC-WWREM-W1)


*@session_timeout_minutes*

	Dallas Value:  3
	Ashburn Value: 3

*@ticket_timeout_minutes*

	Dallas Value:  5
	Ashburn Value: 5

*@session_popup_delay_minutes*

	Dallas Value:  1
	Ashburn Value: 1

*@admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_Admin3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_Admin3g;Trusted_Connection=True

*@auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_AuditLog3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_AuditLog3g;Trusted_Connection=True

*@config_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_Admin3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_Admin3g;Trusted_Connection=True

*@config_auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_AuditLog3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_AuditLog3g;Trusted_Connection=True

*@test_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_Admin3G;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_Admin3G;Trusted_Connection=True

*@test_auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_AuditLog3G;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_AuditLog3G;Trusted_Connection=True

*@CitiToken_EgiBUS_ClientX509SerialNumber*

	Dallas Value:  41 0f 62 13 00 00 00 00 00 c8
	Ashburn Value: 41 0f 62 13 00 00 00 00 00 c8

*@test_CitiToken_EgiBUS_ClientX509SerialNumber*

	Dallas Value:  12 90 89
	Ashburn Value: 12 90 89

*@CitiToken_EGI_ClientX509SerialNumber*

	Dallas Value:  41 0f 62 13 00 00 00 00 00 c8
	Ashburn Value: 41 0f 62 13 00 00 00 00 00 c8

*@test_CitiToken_EGI_ClientX509SerialNumber*

	Dallas Value:  12 90 89
	Ashburn Value: 12 90 89

*@EGI_Signature_Cert*

	Dallas Value:  12 90 89
	Ashburn Value: 12 90 89

*@DR_admin_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

*@DR_auditlog_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_AuditLog3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_AuditLog3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

---

### FDC PDF Web Site (WW-PRD-FDC-WWMSC-W1)


*@admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_Admin3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_Admin3g;Trusted_Connection=True

*@auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_AuditLog3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_AuditLog3g;Trusted_Connection=True

*@storage_proxy*

	Dallas Value: https://dp-esl-spx-01.tisa.io/PRD-ESL-WSSPX-01/synapticWebService.asmx
	Ashburn Value: https://ap-esl-spx-01.tisa.io/PRD-ESL-WSSPX-01/synapticWebService.asmx

*@config_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_Admin3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_Admin3g;Trusted_Connection=True

*@config_auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_AuditLog3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_AuditLog3g;Trusted_Connection=True

*@test_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_Admin3G;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_Admin3G;Trusted_Connection=True

*@test_auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_AuditLog3G;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_AuditLog3G;Trusted_Connection=True

*@DR_admin_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

*@DR_auditlog_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_AuditLog3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_AuditLog3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

---

### FDC Web Service (WS-PRD-FDC-WSREM-W1)

*@ADV3499WACHLBX_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=AdvantaBank;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=AdvantaBank;Trusted_Connection=True

*@UBS0001LBX_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=UBS;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=UBS;Trusted_Connection=True

*@HONDAADC04285673_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Honda;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Honda;Trusted_Connection=True

*@InternalHelper_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_admin3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_admin3g;Trusted_Connection=True

*@InternalHelper_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_archive3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_archive3g;Trusted_Connection=True

*@storage_proxy*

	Dallas Value: https://dp-esl-spx-01.tisa.io/PRD-ESL-WSSPX-01/synapticWebService.asmx
	Ashburn Value: https://ap-esl-spx-01.tisa.io/PRD-ESL-WSSPX-01/synapticWebService.asmx

*@config_ADV3499WACHLBX_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=EmdeonDemo;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=EmdeonDemo;Trusted_Connection=True

*@config_UBS0001LBX_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=EmdeonDemo;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=EmdeonDemo;Trusted_Connection=True

*@config_HONDAADC04285673_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=EmdeonDemo;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=EmdeonDemo;Trusted_Connection=True

*@config_InternalHelper_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_Admin3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_Admin3g;Trusted_Connection=True

*@config_InternalHelper_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=EmdeonDemo;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=EmdeonDemo;Trusted_Connection=True

*@config_DEMOLBX_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=EmdeonDemo;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=EmdeonDemo;Trusted_Connection=True
  
*@test_ADV3499WACHLBX_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_EmdeonDemo;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_EmdeonDemo;Trusted_Connection=True

*@test_UBS0001LBX_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_EmdeonDemo;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_EmdeonDemo;Trusted_Connection=True

*@test_HONDAADC04285673_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_EmdeonDemo;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_EmdeonDemo;Trusted_Connection=True

*@test_InternalHelper_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_Admin3G;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_Admin3G;Trusted_Connection=True

*@test_InternalHelper_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_EmdeonDemo;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_EmdeonDemo;Trusted_Connection=True

*@test_DEMOLBX_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_EmdeonDemo;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_EmdeonDemo;Trusted_Connection=True
  
*@DR_ADV3499WACHLBX_archive_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

*@DR_UBS0001LBX_archive_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

*@DR_HONDAADC04285673_archive_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

*@DR_InternalHelper_admin_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

*@DR_InternalHelper_archive_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

*@DR_DEMOLBX_archive_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_EmdeonDemo;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
  
---

### FDC Audit Event Processor (ES-PRD-FDC-ESMSC-W1)

*@auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_AuditLog3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_AuditLog3g;Trusted_Connection=True

*@config_auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_AuditLog3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_AuditLog3g;Trusted_Connection=True

*@test_auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_AuditLog3G;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_AuditLog3G;Trusted_Connection=True
  
*@DR_auditlog_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_AuditLog3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_AuditLog3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
  
---

### FDC LMS Web Site (PRD-FDC-WWLMS-W1)

*@admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_Admin3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_Admin3g;Trusted_Connection=True

*@auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=rtc_AuditLog3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=rtc_AuditLog3g;Trusted_Connection=True

*@config_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_Admin3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_Admin3g;Trusted_Connection=True

*@config_auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_AuditLog3g;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Config_rtc_AuditLog3g;Trusted_Connection=True

*@test_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_Admin3G;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_Admin3G;Trusted_Connection=True

*@test_auditlog_db*

	Dallas Value:  SERVER=DP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_AuditLog3G;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-01.egistics.local;DATABASE=TEST_RTC_AuditLog3G;Trusted_Connection=True

*@DR_admin_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_Admin3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

*@DR_auditlog_db*

	Dallas Value:  SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_AuditLog3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36
	Ashburn Value: SERVER=FDC-TST-AG1.egistics.local;DATABASE=TEST_RTC_AuditLog3G;MultiSubnetFailover=Yes;Integrated Security=SSPI;Connect Timeout=36

---	

FDC MS CDMWrapper (WS-PRD-FDC-WSCDM-E1)

*@test_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_Admin;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_Admin;Trusted_Connection=True
	
*@test_archive_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_MorganStanley;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_MorganStanley;Trusted_Connection=True
	
*@test_audit_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_AuditLog;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_AuditLog;Trusted_Connection=True
	
@storage_proxy

    Dallas Value: https://dp-esl-spx-01.tisa.io/PRD-ESL-WSSPX-01/synapticWebService.asmx
    Ashburn Value: https://ap-esl-spx-01.tisa.io/PRD-ESL-WSSPX-01/synapticWebService.asmx
	
---

FDC Remit Core Website (WW-PRD-FDC-WWREM-W2)

*@test_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_Admin;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_Admin;Trusted_Connection=True
	

*@test_audit_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_AuditLog;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_AuditLog;Trusted_Connection=True
	
@storage_proxy

   Dallas Value: https://dp-esl-spx-01.tisa.io/PRD-ESL-WSSPX-01/synapticWebService.asmx
   Ashburn Value: https://ap-esl-spx-01.tisa.io/PRD-ESL-WSSPX-01/synapticWebService.asmx

---

FDC LMS Website  PRD (WW-PRD-FDC-WWLMS-W2)

*@test_admin_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_Admin;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_Admin;Trusted_Connection=True
	

*@test_audit_db*

	Dallas Value:  SERVER=DP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_AuditLog;Trusted_Connection=True
	Ashburn Value: SERVER=AP-FDC-SQL-02.egistics.local;DATABASE=Test_FDC_AuditLog;Trusted_Connection=True

*@EGI_Signature_Cert*

    Value:

