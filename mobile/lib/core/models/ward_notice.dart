enum NoticeUrgency { info, advisory, critical }

class WardNotice {
  final String id;
  final String title;
  final String titleHi;
  final String description;
  final String descriptionHi;
  final String wardId;
  final String wardName;
  final NoticeUrgency urgency;
  final DateTime effectiveFrom;
  final DateTime effectiveTo;
  final String authorityContact;

  const WardNotice({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.description,
    required this.descriptionHi,
    required this.wardId,
    required this.wardName,
    required this.urgency,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.authorityContact,
  });

  static List<WardNotice> defaultNotices() {
    final now = DateTime.now();
    return [
      WardNotice(
        id: 'NOT-01',
        title: 'Water Supply Shutdown for Booster Maintenance',
        titleHi: 'बूस्टर पंप रखरखाव हेतु जल आपूर्ति बंद',
        description: 'Water supply will be paused from 10:00 AM to 4:00 PM across Civil Lines for replacement of main pressure valve.',
        descriptionHi: 'मुख्य प्रेशर वाल्व बदलने हेतु सिविल लाइंस में प्रातः 10:00 से सायं 4:00 बजे तक जलापूर्ति बाधित रहेगी।',
        wardId: 'W-01',
        wardName: 'Civil Lines',
        urgency: NoticeUrgency.advisory,
        effectiveFrom: now.add(const Duration(hours: 12)),
        effectiveTo: now.add(const Duration(hours: 18)),
        authorityContact: 'Jal Board Helpline: 011-23548899',
      ),
      WardNotice(
        id: 'NOT-02',
        title: 'Ward Sabha: Public Grievance Open Townhall',
        titleHi: 'वार्ड सभा: नागरिक शिकायत जन-सुनवाई',
        description: 'Monthly open council with Ward Officer Sanjay Verma and civic engineers to discuss monsoon drainage and roads.',
        descriptionHi: 'नाली सफाई एवं सड़क मरम्मत पर चर्चा हेतु वार्ड अधिकारी एवं क्षेत्रीय इंजीनियरों के साथ खुली जनसुनवाई।',
        wardId: 'W-01',
        wardName: 'Civil Lines',
        urgency: NoticeUrgency.info,
        effectiveFrom: now.add(const Duration(days: 2)),
        effectiveTo: now.add(const Duration(days: 2, hours: 3)),
        authorityContact: 'Community Hall, Sector 4',
      ),
      WardNotice(
        id: 'NOT-03',
        title: 'Emergency Storm Drain Cleaning: Road Diversion',
        titleHi: 'आपातकालीन नाला सफाई: यातायात डायवर्जन',
        description: 'Heavy machinery operating on Main Market Road. Heavy vehicles rerouted via Ring Road till midnight.',
        descriptionHi: 'मेन मार्केट रोड पर भारी मशीनों से सफाई कार्य जारी। भारी वाहन रिंग रोड से डायवर्ट किए गए हैं।',
        wardId: 'W-02',
        wardName: 'Gandhi Nagar',
        urgency: NoticeUrgency.critical,
        effectiveFrom: now.subtract(const Duration(hours: 2)),
        effectiveTo: now.add(const Duration(hours: 10)),
        authorityContact: 'Traffic Control Room: 103',
      ),
    ];
  }
}
