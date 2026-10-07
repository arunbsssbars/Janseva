class CivicScheme {
  final String id;
  final String title;
  final String titleHi;
  final String department;
  final String category;
  final String benefitSummary;
  final String benefitSummaryHi;
  final int maxIncomePerAnnum;
  final List<String> requiredDocuments;
  final String officialPortalUrl;

  const CivicScheme({
    required this.id,
    required this.title,
    required this.titleHi,
    required this.department,
    required this.category,
    required this.benefitSummary,
    required this.benefitSummaryHi,
    required this.maxIncomePerAnnum,
    required this.requiredDocuments,
    required this.officialPortalUrl,
  });

  static List<CivicScheme> getPreloadedSchemes() => const [
    CivicScheme(
      id: 'SCH-01',
      title: 'PM SVANidhi (Street Vendor Support)',
      titleHi: 'पीएम स्वनिधि (स्ट्रीट वेंडर आत्मनिर्भर निधि)',
      department: 'Ministry of Housing and Urban Affairs',
      category: 'Livelihood & Small Business',
      benefitSummary: 'Working capital loan up to ₹50,000 with 7% interest subsidy and cashback on digital transactions.',
      benefitSummaryHi: 'डिजिटल लेनदेन पर कैशबैक और 7% ब्याज सब्सिडी के साथ ₹50,000 तक का कार्यशील पूंजी ऋण।',
      maxIncomePerAnnum: 300000,
      requiredDocuments: ['Aadhaar Card', 'Vending Certificate / Urban Livelihood ID', 'Bank Account Details'],
      officialPortalUrl: 'https://pmsvanidhi.mohua.gov.in',
    ),
    CivicScheme(
      id: 'SCH-02',
      title: 'Ayushman Bharat - PM-JAY',
      titleHi: 'आयुष्मान भारत - प्रधानमंत्री जन आरोग्य योजना',
      department: 'National Health Authority',
      category: 'Healthcare & Medical',
      benefitSummary: 'Cashless hospital coverage up to ₹5,00,000 per family per year across empaneled public & private hospitals.',
      benefitSummaryHi: 'सूचीबद्ध सरकारी एवं निजी अस्पतालों में प्रति वर्ष प्रति परिवार ₹5,00,000 तक कैशलेस उपचार सुरक्षा।',
      maxIncomePerAnnum: 250000,
      requiredDocuments: ['Ration Card', 'Aadhaar Card', 'SECC Family Verification'],
      officialPortalUrl: 'https://pmjay.gov.in',
    ),
    CivicScheme(
      id: 'SCH-03',
      title: 'PM Surya Ghar: Muft Bijli Yojana',
      titleHi: 'पीएम सूर्य घर: मुफ्त बिजली योजना',
      department: 'Ministry of New & Renewable Energy',
      category: 'Clean Energy & Electricity',
      benefitSummary: 'Subsidy up to ₹78,000 for installing residential rooftop solar systems and 300 free monthly power units.',
      benefitSummaryHi: 'छत पर सौर ऊर्जा संयंत्र स्थापित करने के लिए ₹78,000 तक की सब्सिडी और 300 यूनिट तक मुफ्त बिजली।',
      maxIncomePerAnnum: 800000,
      requiredDocuments: ['Electricity Bill', 'Roof Ownership Proof', 'Bank Passbook'],
      officialPortalUrl: 'https://pmsuryaghar.gov.in',
    ),
    CivicScheme(
      id: 'SCH-04',
      title: 'PM Awas Yojana (Urban 2.0)',
      titleHi: 'प्रधानमंत्री आवास योजना (शहरी 2.0)',
      department: 'Urban Development Directorate',
      category: 'Affordable Housing',
      benefitSummary: 'Interest subsidy on home loans and direct financial assistance of up to ₹2.5 Lakh for pucca house construction.',
      benefitSummaryHi: 'पक्का मकान निर्माण या गृह ऋण पर ₹2.5 लाख तक की सीधी सरकारी वित्तीय सहायता एवं ब्याज सब्सिडी।',
      maxIncomePerAnnum: 600000,
      requiredDocuments: ['Aadhaar Card', 'Income Certificate', 'Land Registry / NOC'],
      officialPortalUrl: 'https://pmay-urban.gov.in',
    ),
  ];
}
