class MunicipalCorporationInfo {
  final String id;
  final String nameEn;
  final String nameHi;
  final String stateName;
  final String cmHelplineNumber;
  final String municipalHelpline;
  final String discomName;
  final String discomHelpline;
  final String jalBoardName;
  final String jalBoardHelpline;
  final String defaultPincode;
  final List<String> sampleLocalities;

  const MunicipalCorporationInfo({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    required this.stateName,
    required this.cmHelplineNumber,
    required this.municipalHelpline,
    required this.discomName,
    required this.discomHelpline,
    required this.jalBoardName,
    required this.jalBoardHelpline,
    required this.defaultPincode,
    required this.sampleLocalities,
  });
}

class PanIndiaDirectory {
  static const List<MunicipalCorporationInfo> corporations = [
    MunicipalCorporationInfo(
      id: 'MCD_DELHI',
      nameEn: 'Municipal Corporation of Delhi (MCD)',
      nameHi: 'दिल्ली नगर निगम',
      stateName: 'Delhi NCR',
      cmHelplineNumber: '1031',
      municipalHelpline: '1800-11-8700',
      discomName: 'BSES Rajdhani / Tata Power DDL',
      discomHelpline: '1912',
      jalBoardName: 'Delhi Jal Board (DJB)',
      jalBoardHelpline: '1916',
      defaultPincode: '110054',
      sampleLocalities: ['Civil Lines', 'Rohini Sector 15', 'Lajpat Nagar', 'Dwarka Sector 10', 'Karol Bagh'],
    ),
    MunicipalCorporationInfo(
      id: 'LNN_LUCKNOW',
      nameEn: 'Lucknow Nagar Nigam (LNN)',
      nameHi: 'लखनऊ नगर निगम',
      stateName: 'Uttar Pradesh',
      cmHelplineNumber: '1076',
      municipalHelpline: '1533',
      discomName: 'Madhyanchal Vidyut Vitran Nigam (MVVNL)',
      discomHelpline: '1912',
      jalBoardName: 'UP Jal Nigam / Jal Sansthan',
      jalBoardHelpline: '1800-180-8776',
      defaultPincode: '226001',
      sampleLocalities: ['Hazratganj', 'Gomti Nagar', 'Aliganj', 'Indira Nagar', 'Chowk'],
    ),
    MunicipalCorporationInfo(
      id: 'BMC_MUMBAI',
      nameEn: 'Brihanmumbai Municipal Corporation (BMC)',
      nameHi: 'बृहन्मुंबई महानगरपालिका',
      stateName: 'Maharashtra',
      cmHelplineNumber: '1800-120-8040',
      municipalHelpline: '1916',
      discomName: 'MSEDCL / Adani Electricity / BEST',
      discomHelpline: '1912',
      jalBoardName: 'BMC Hydraulic Engineer Department',
      jalBoardHelpline: '1916',
      defaultPincode: '400001',
      sampleLocalities: ['Andheri West', 'Dadar', 'Bandra', 'Borivali', 'Kurla'],
    ),
    MunicipalCorporationInfo(
      id: 'BBMP_BENGALURU',
      nameEn: 'Bruhat Bengaluru Mahanagara Palike (BBMP)',
      nameHi: 'बृहत बेंगलुरु महानगर पालिके',
      stateName: 'Karnataka',
      cmHelplineNumber: '1902',
      municipalHelpline: '1533',
      discomName: 'Bangalore Electricity Supply (BESCOM)',
      discomHelpline: '1912',
      jalBoardName: 'Bangalore Water Supply (BWSSB)',
      jalBoardHelpline: '1916',
      defaultPincode: '560001',
      sampleLocalities: ['Indiranagar', 'Koramangala', 'Whitefield', 'Jayanagar', 'HSR Layout'],
    ),
    MunicipalCorporationInfo(
      id: 'IMC_INDORE',
      nameEn: 'Indore Municipal Corporation (IMC - #1 Swachh City)',
      nameHi: 'इंदौर नगर निगम',
      stateName: 'Madhya Pradesh',
      cmHelplineNumber: '181',
      municipalHelpline: '311',
      discomName: 'MP Pashchim Kshetra Vidyut Vitaran',
      discomHelpline: '1912',
      jalBoardName: 'Narmada Water Works Department',
      jalBoardHelpline: '0731-2537111',
      defaultPincode: '452001',
      sampleLocalities: ['Vijay Nagar', 'Palasia', 'Rajwada', 'Bhawarkua', 'Sudama Nagar'],
    ),
    MunicipalCorporationInfo(
      id: 'PMC_PATNA',
      nameEn: 'Patna Municipal Corporation (PMC)',
      nameHi: 'पटना नगर निगम',
      stateName: 'Bihar',
      cmHelplineNumber: '1800-345-6268',
      municipalHelpline: '155304',
      discomName: 'South Bihar Power Distribution (SBPDCL)',
      discomHelpline: '1912',
      jalBoardName: 'Patna Water Board & Sewerage',
      jalBoardHelpline: '0612-2200634',
      defaultPincode: '800001',
      sampleLocalities: ['Kankarbagh', 'Boring Road', 'Bailey Road', 'Patliputra Colony', 'Rajendra Nagar'],
    ),
    MunicipalCorporationInfo(
      id: 'JMC_JAIPUR',
      nameEn: 'Jaipur Nagar Nigam (Heritage & Greater)',
      nameHi: 'जयपुर नगर निगम',
      stateName: 'Rajasthan',
      cmHelplineNumber: '181',
      municipalHelpline: '1800-180-6666',
      discomName: 'Jaipur Vidyut Vitran Nigam (JVVNL)',
      discomHelpline: '1912',
      jalBoardName: 'Public Health Engineering Dept (PHED)',
      jalBoardHelpline: '181',
      defaultPincode: '302001',
      sampleLocalities: ['Malviya Nagar', 'Vaishali Nagar', 'Mansarovar', 'C-Scheme', 'Raja Park'],
    ),
  ];

  static MunicipalCorporationInfo get defaultCorporation => corporations.first;

  static MunicipalCorporationInfo findByPincodeOrLocality(String input) {
    final query = input.trim().toLowerCase();
    for (final corp in corporations) {
      if (corp.defaultPincode.contains(query)) return corp;
      for (final loc in corp.sampleLocalities) {
        if (loc.toLowerCase().contains(query)) return corp;
      }
      if (corp.stateName.toLowerCase().contains(query)) return corp;
      if (corp.nameEn.toLowerCase().contains(query)) return corp;
    }
    return defaultCorporation;
  }
}
