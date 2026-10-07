import '../models/civic_machinery_tranche2.dart';
import '../models/civic_machinery_tranche3.dart';
import '../models/civic_machinery_tranche4.dart';
import '../models/discom_safety_audit.dart';
import '../models/manhole_hazard_audit.dart';
import '../models/ngt_solid_waste_audit.dart';
import '../models/pwd_road_inspection.dart';
import '../models/water_potability_audit.dart';

enum CivicMachineryCategory {
  roadsAndInfra(titleEn: 'Roads & Infrastructure', titleHi: 'सड़क एवं बुनियादी ढांचा'),
  waterAndHealth(titleEn: 'Drinking Water & Sanitation', titleHi: 'पेयजल एवं स्वच्छता'),
  powerAndUtilities(titleEn: 'Electricity & Utilities', titleHi: 'बिजली एवं उपयोगिताएं'),
  environmentAndAir(titleEn: 'Environment & Pollution', titleHi: 'पर्यावरण एवं प्रदूषण नियंत्रण'),
  socialWelfareAndSafety(titleEn: 'Public Safety & Welfare', titleHi: 'नागरिक सुरक्षा एवं कल्याण'),
  revenueAndTransparency(titleEn: 'Revenue, Law & Anti-Corruption', titleHi: 'राजस्व, कानून एवं सतर्कता');

  final String titleEn;
  final String titleHi;
  const CivicMachineryCategory({required this.titleEn, required this.titleHi});
}

class CivicCaseItem {
  final int caseNumber;
  final String titleEn;
  final String titleHi;
  final String statutoryAct;
  final String authorityEn;
  final String authorityHi;
  final CivicMachineryCategory category;
  final String summaryEn;
  final String summaryHi;
  final String penaltyOrReliefEn;
  final String penaltyOrReliefHi;
  final String Function() petitionGenerator;

  const CivicCaseItem({
    required this.caseNumber,
    required this.titleEn,
    required this.titleHi,
    required this.statutoryAct,
    required this.authorityEn,
    required this.authorityHi,
    required this.category,
    required this.summaryEn,
    required this.summaryHi,
    required this.penaltyOrReliefEn,
    required this.penaltyOrReliefHi,
    required this.petitionGenerator,
  });
}

class GovtMachineryRegistry {
  static List<CivicCaseItem> getAllCases() {
    return [
      // 1. PWD Road DLP
      CivicCaseItem(
        caseNumber: 1,
        titleEn: 'PWD Road Defect Liability Period (DLP) & Pothole Hazard',
        titleHi: 'पीडब्ल्यूडी सड़क गारंटी (डीएलपी) एवं गड्ढा मरम्मत',
        statutoryAct: 'CPWD Works Manual Clause 14 & 17',
        authorityEn: 'Executive Engineer (PWD / ULB Road Wing)',
        authorityHi: 'अधिशासी अभियंता (लोक निर्माण विभाग)',
        category: CivicMachineryCategory.roadsAndInfra,
        summaryEn: 'Enforces free contractor repairs and accumulated daily penalty on defaulted road builders.',
        summaryHi: 'गारंटी अवधि में गड्ढों की निःशुल्क मरम्मत और ठेकेदार पर दैनिक जुर्माना।',
        penaltyOrReliefEn: 'Contractor penalty up to ₹5,000/day + security deposit forfeiture',
        penaltyOrReliefHi: 'ठेकेदार पर ₹5,000/दिन तक जुर्माना एवं जमानत राशि जब्ती',
        petitionGenerator: () => const PwdRoadDefectAudit(
          roadName: 'Main Ring Road Sector 14',
          wardName: 'Civil Lines',
          lengthInMeters: 450,
          potholeCount: 12,
          hasWaterLogging: true,
          contractor: PwdRoadContractor(
            contractorId: 'CONTR-881',
            companyName: 'Apex Infra Projects Pvt Ltd',
            workOrderNumber: 'WO-PWD-2025-0912',
            completionDate: null,
            dlpExpiryDate: null,
            contractValueInLakhs: 85.0,
            penaltyPerDay: 3500.0,
          ),
          dlpStatus: DlpStatus.emergencyBreach,
        ).generateExecutiveEngineerNotice(grievanceDocket: 'DLP-2026-001', daysDelayed: 14),
      ),

      // 2. Potable Water BIS 10500
      CivicCaseItem(
        caseNumber: 2,
        titleEn: 'Safe Drinking Water BIS 10500 Lab Testing Requisition',
        titleHi: 'सुरक्षित पेयजल परीक्षण (बीआईएस 10500 मानक)',
        statutoryAct: 'Bureau of Indian Standards (BIS 10500:2012) & Public Health Act',
        authorityEn: 'Chief Chemist, Water Works / District Health Officer (CMO)',
        authorityHi: 'मुख्य रसायनज्ञ, जल बोर्ड / मुख्य चिकित्सा अधिकारी',
        category: CivicMachineryCategory.waterAndHealth,
        summaryEn: 'Demands mobile lab van sampling, tanker deployment, and coliform bacterial testing.',
        summaryHi: 'दूषित नल जल की प्रयोगशाला जांच, टैंकर आपूर्ति और ई-कोलाई बैक्टीरिया परीक्षण।',
        penaltyOrReliefEn: 'Free clean water tanker dispatch within 12h + boil water notice',
        penaltyOrReliefHi: '12 घंटे में निःशुल्क पेयजल टैंकर आपूर्ति एवं नोटिस',
        petitionGenerator: () => const WaterQualityTestReport(
          phLevel: 6.2,
          turbidityNtu: 8.5,
          tdsPpm: 720.0,
          residualChlorinePpm: 0.05,
          coliformCountPer100ml: 14,
          hasFecalOdor: true,
        ).generateLabRequisitionPetition(
          locality: 'Vivekananda Nagar',
          wardName: 'Ward 12',
          consumerKNumber: 'DJB-WATER-99412',
        ),
      ),

      // 3. DISCOM Electrical Safety & Surge Compensation
      CivicCaseItem(
        caseNumber: 3,
        titleEn: 'DISCOM 1912 Electrical Safety & Transformer Surge Claim',
        titleHi: 'विद्युत सुरक्षा, ट्रांसफार्मर खराबी एवं उपकरण मुआवजा',
        statutoryAct: 'Electricity Act 2003 & SERC Standards of Performance Regulations',
        authorityEn: 'Superintending Engineer, DISCOM / Electricity Ombudsman',
        authorityHi: 'अधीक्षण अभियंता, विद्युत वितरण निगम / विद्युत लोकपाल',
        category: CivicMachineryCategory.powerAndUtilities,
        summaryEn: 'Mandates transformer replacement within SLA and statutory compensation for outage/burnout.',
        summaryHi: 'समय सीमा में ट्रांसफार्मर मरम्मत और उपकरण जलने पर वैधानिक मुआवजा।',
        penaltyOrReliefEn: '₹50/hour outage penalty + electrical appliance damage indemnity',
        penaltyOrReliefHi: '₹50/घंटा देरी मुआवजा + जले हुए उपकरणों की क्षतिपूर्ति',
        petitionGenerator: () => const DiscomHazardReport(
          caNumber: '1004928172',
          discomName: 'State Electricity Distribution Company',
          feederName: 'Indira Feeder 11kV',
          transformerId: 'DT-42/Sector-B',
          subDivision: 'North Division',
          hasLooseHangingWire: true,
          hasTransformerSparking: true,
          hasHighVoltageSurge: true,
          outageHours: 26,
          estimatedApplianceLossInRupees: 35000.0,
        ).generateDiscomCompensationPetition(),
      ),

      // 4. NGT Solid Waste & Open Burning
      CivicCaseItem(
        caseNumber: 4,
        titleEn: 'NGT Solid Waste Rules & Open Toxic Garbage Burning',
        titleHi: 'एनजीटी ठोस अपशिष्ट नियम एवं खुले में कचरा जलाना निषेध',
        statutoryAct: 'Solid Waste Management Rules 2016 & NGT Principal Bench Directives',
        authorityEn: 'Member Secretary, State Pollution Control Board & Municipal Commissioner',
        authorityHi: 'सदस्य सचिव, राज्य प्रदूषण नियंत्रण बोर्ड एवं नगर आयुक्त',
        category: CivicMachineryCategory.environmentAndAir,
        summaryEn: 'Invokes mandatory spot environmental compensation for open plastic/waste combustion.',
        summaryHi: 'खुले में प्लास्टिक/कचरा जलाने पर त्वरित पर्यावरणीय जुर्माना एवं सफाई।',
        penaltyOrReliefEn: '₹5,000 spot fine for waste burning + compactor dispatch in 6h',
        penaltyOrReliefHi: 'कचरा जलाने पर ₹5,000 जुर्माना + 6 घंटे में निस्तारण',
        petitionGenerator: () => const SolidWasteViolationReport(
          locationAddress: 'Corner Plot near Metro Pillar 140, Outer Road',
          wardName: 'Shahdara North',
          corporationName: 'Municipal Corporation',
          isOpenGarbageBurning: true,
          isSecondaryDhalaoOverflow: true,
          isLeachateFlowingOnRoad: true,
          daysAccumulated: 5,
        ).generateNgtViolationPetition(complaintDocket: 'NGT-SWM-2026-901'),
      ),

      // 5. Open Manhole Section 133 CrPC
      CivicCaseItem(
        caseNumber: 5,
        titleEn: 'Open Manhole Death-Trap Emergency (Section 133 CrPC / 152 BNSS)',
        titleHi: 'खुला सीवर मैनहोल आपातकालीन आदेश (धारा 133 सीआरपीसी)',
        statutoryAct: 'Section 133 CrPC (Sec 152 BNSS) & Supreme Court Ratlam Precedent',
        authorityEn: 'Sub-Divisional Magistrate (SDM) / Executive Magistrate',
        authorityHi: 'उप-जिला मजिस्ट्रेट (एसडीएम) / कार्यपालक मजिस्ट्रेट',
        category: CivicMachineryCategory.roadsAndInfra,
        summaryEn: 'Emergency magisterial conditional order for mandatory heavy cover installation and police barricades.',
        summaryHi: 'मानव जीवन सुरक्षा हेतु मजिस्ट्रेट का त्वरित आदेश एवं बैरिकेडिंग।',
        penaltyOrReliefEn: 'Mandatory 12h SFRC cover installation + criminal negligence inquiry',
        penaltyOrReliefHi: '12 घंटे में पक्का ढक्कन + आपराधिक लापरवाही जांच',
        petitionGenerator: () => const ManholeHazardReport(
          locationAddress: 'School Road, Opp Modern Public School Gate',
          wardName: 'Civil Lines Sub-Division',
          nearestLandmark: 'Modern Public School',
          isCompletelyOpen: true,
          hasBrokenCastIronCover: true,
          isNearSchoolOrHospital: true,
          isSubmergedUnderMonsoonWater: true,
          daysReportedUnrepaired: 8,
        ).generateSdmSection133Petition(docketId: 'EMG-MANHOLE-771'),
      ),

      // 6. Animal Control & Anti-Rabies
      CivicCaseItem(
        caseNumber: 6,
        titleEn: 'Animal Birth Control (ABC 2023) & Anti-Rabies Vaccine Protocol',
        titleHi: 'पशु जन्म नियंत्रण (एबीसी 2023) एवं रेबीज रोधी टीकाकरण',
        statutoryAct: 'Animal Birth Control Rules 2023 & Prevention of Cruelty to Animals Act',
        authorityEn: 'Veterinary Officer, ABC Monitoring Cell (Animal Husbandry)',
        authorityHi: 'पशु चिकित्सा अधिकारी, नगर निगम एबीसी सेल',
        category: CivicMachineryCategory.socialWelfareAndSafety,
        summaryEn: 'Humane capture, surgical sterilization, rabies booster, and hospital vaccine availability check.',
        summaryHi: 'आवारा कुत्तों की नसबंदी, एंटी-रेबीज टीका और सरकारी अस्पताल में वैक्सीन ट्रैकिंग।',
        penaltyOrReliefEn: 'Mandatory humane ambulance catching within 48h + hospital ARV stock check',
        penaltyOrReliefHi: '48 घंटे में एंबुलेंस द्वारा टीकाकरण + अस्पताल में रेबीज टीका जांच',
        petitionGenerator: () => const AnimalControlIncidentReport(
          wardName: 'Karol Bagh Zone',
          streetAddress: 'Block 7, Gali No 3, Market Lane',
          packSize: 9,
          hasAggressiveBiteIncident: true,
          areDogsEarNotched: false,
          nearestGovtHospitalWithArv: 'Deen Dayal Upadhyay Hospital',
        ).generateAbcCellRequisition(),
      ),

      // 7. Property Tax Section 138 Appeal
      CivicCaseItem(
        caseNumber: 7,
        titleEn: 'Property Tax Over-Assessment & Section 138 Municipal Appeal',
        titleHi: 'हाउस टैक्स मनमाना नोटिस एवं धारा 138 वैधानिक अपील',
        statutoryAct: 'Section 138 of Municipal Corporation Act (Unit Area System)',
        authorityEn: 'Assessor & Collector, Municipal Valuation Tribunal',
        authorityHi: 'मूल्यांकन एवं कर संग्रहकर्ता, नगर निगम राजस्व अधिकरण',
        category: CivicMachineryCategory.revenueAndTransparency,
        summaryEn: 'Halts recovery distress warrants and recalculates correct tax under unit area method.',
        summaryHi: 'गलत हाउस टैक्स बिल पर रोक और यूनिट एरिया फार्मूले से शुद्ध गणना।',
        penaltyOrReliefEn: 'Stay on bank attachment/auction + correction of excess demand',
        penaltyOrReliefHi: 'खाता जब्ती और कुर्की पर रोक + बिल का शुद्धिकरण',
        petitionGenerator: () => const PropertyTaxAssessmentAppeal(
          propertyUpicNumber: 'UPIC-DEL-RES-88210',
          ownerName: 'Suresh Chandra Sharma',
          colonyCategory: 'D',
          coveredAreaSqMtr: 145.0,
          municipalDemandedTax: 78500.0,
          correctCalculatedTax: 16400.0,
        ).generateSection138AppealPetition(assessmentYear: '2025-2026'),
      ),

      // 8. Street Vendors Act 2014 TVC
      CivicCaseItem(
        caseNumber: 8,
        titleEn: 'Street Vendors Act 2014 & Footpath Pedestrian Deconfliction',
        titleHi: 'स्ट्रीट वेंडर्स आजीविका संरक्षण एवं फुटपाथ अतिक्रमण मुक्ति',
        statutoryAct: 'Street Vendors (Protection of Livelihood & Regulation) Act 2014',
        authorityEn: 'Town Vending Committee (TVC) & Ward Enforcement Wing',
        authorityHi: 'टाउन वेंडिंग कमेटी एवं प्रवर्तन दल',
        category: CivicMachineryCategory.revenueAndTransparency,
        summaryEn: 'Protects licensed street vendors from extortion while clearing 1.5m pedestrian footpath lines.',
        summaryHi: 'वैध पटरी दुकानदारों को उत्पीड़न से सुरक्षा और पैदल यात्रियों के लिए 1.5मी रास्ता।',
        penaltyOrReliefEn: 'Protection from eviction under Sec 3(3) + 1.5m yellow line pedestrian zoning',
        penaltyOrReliefHi: 'धारा 3(3) में जब्ती से सुरक्षा + फुटपाथ पर पैदल यात्रियों हेतु पीली पट्टी',
        petitionGenerator: () => const StreetVendingComplianceRecord(
          vendorCertificateId: 'COV-VENDOR-2024-510',
          vendorName: 'Mohammad Rafiq',
          vendingZoneCategory: 'Designated Stationary Vending Zone',
          isEncroachingPedestrianWalkway: true,
          isExtortedByUnauthorizedPersons: true,
        ).generateTownVendingCommitteePetition(wardName: 'Lajpat Nagar Central'),
      ),

      // 9. Noise Pollution Rules 2000
      CivicCaseItem(
        caseNumber: 9,
        titleEn: 'Noise Pollution Rules 2000 & SDM/Police 112 Equipment Seizure',
        titleHi: 'ध्वनि प्रदूषण नियम 2000 एवं रात 10 बजे बाद डीजे/लाउडस्पीकर जब्ती',
        statutoryAct: 'Noise Pollution (Regulation & Control) Rules 2000 & Env Protection Act',
        authorityEn: 'Station House Officer (Police 112) & Sub-Divisional Magistrate (SDM)',
        authorityHi: 'थाना प्रभारी (पुलिस 112) एवं एसडीएम पर्यावरण प्रकोष्ठ',
        category: CivicMachineryCategory.environmentAndAir,
        summaryEn: 'Emergency police dispatch for decibel breach, un-muffled DG sets, and late-night audio seizure.',
        summaryHi: 'रात में तेज लाउडस्पीकर/जनरेटर पर 112 पुलिस कार्रवाई और उपकरण जब्ती।',
        penaltyOrReliefEn: 'Seizure of sound amplifiers under Rule 8 + prosecution under Section 19 EPA',
        penaltyOrReliefHi: 'उपकरणों की जब्ती एवं पर्यावरण संरक्षण अधिनियम में मुकदमा',
        petitionGenerator: () => NoisePollutionViolationReport(
          locality: 'Sector 23 Green Park Colony',
          soundSource: 'Commercial Open Lawn Banquet DG Set & High-Wattage Amplifier',
          measuredDecibels: 78.4,
          incidentTime: DateTime.now(),
          isSilenceZone: false,
        ).generateNoiseRestraintPetition(),
      ),

      // 10. Safe City Streetlight SLA
      CivicCaseItem(
        caseNumber: 10,
        titleEn: 'Safe City Dark-Spot & Streetlight Maintenance 48-Hour SLA',
        titleHi: 'सेफ सिटी डार्क-स्पॉट एवं स्ट्रीटलाइट 48 घंटे मरम्मत गारंटी',
        statutoryAct: 'Ministry of Home Affairs Safe City Guidelines & Municipal Lighting SLA',
        authorityEn: 'Nodal Officer, Smart City Street Lighting (EESL / DISCOM)',
        authorityHi: 'स्मार्ट सिटी स्ट्रीट लाइटिंग नोडल अधिकारी (ईईएसएल)',
        category: CivicMachineryCategory.socialWelfareAndSafety,
        summaryEn: 'Eliminates dark transit corridors dangerous for women and night commuters within 48h SLA.',
        summaryHi: 'महिला सुरक्षा एवं रात्रि यात्रियों हेतु अंधेरे रास्तों पर 48 घंटे में लाइट दुरुस्त।',
        penaltyOrReliefEn: 'Mandatory 48h replacement of defunct LED luminaire and cable faults',
        penaltyOrReliefHi: '48 घंटे में नई एलईडी लाइट और भूमिगत केबल मरम्मत',
        petitionGenerator: () => const StreetlightDarkSpotAudit(
          poleNumber: 'LED-PL-941/East',
          streetName: 'Girls College Transit Link Road',
          wardName: 'Alambagh',
          consecutiveDarkPoles: 6,
          isWomenTransitCorridor: true,
          daysDark: 7,
        ).generateSafeCityLightingPetition(),
      ),

      // 11. Tree Preservation Act
      CivicCaseItem(
        caseNumber: 11,
        titleEn: 'Preservation of Trees Act & Illegal Felling Stop-Work Order',
        titleHi: 'वृक्ष संरक्षण अधिनियम एवं अवैध कटाई पर पुलिस रोक',
        statutoryAct: 'Delhi / State Preservation of Trees Act & Indian Forest Act 1927',
        authorityEn: 'Tree Officer & Deputy Conservator of Forests (DCF)',
        authorityHi: 'वृक्ष अधिकारी एवं उप वन संरक्षक (वन विभाग)',
        category: CivicMachineryCategory.environmentAndAir,
        summaryEn: 'Immediate halt to illegal tree felling, machinery confiscation, and mandatory 10-sapling compensatory plantation.',
        summaryHi: 'बिना अनुमति पेड़ काटने पर आरी/जेसीबी जब्ती और 10 गुना नए पौधे लगाने का आदेश।',
        penaltyOrReliefEn: 'Cognizable FIR under Section 24 + forfeiture of machinery + 10x compensatory trees',
        penaltyOrReliefHi: 'धारा 24 में एफआईआर + मशीनरी जब्ती + 10 गुना क्षतिपूर्ति पौधरोपण',
        petitionGenerator: () => const TreeProtectionIncidentReport(
          location: 'Community Park Perimeter, Pocket B',
          wardName: 'Rohini Sector 15',
          treeSpecies: 'Mature Neem & Peepal (40+ years old)',
          numberOfTrees: 3,
          isOngoingFellingActivity: true,
          hasTreeOfficerPermitShown: false,
        ).generateTreeOfficerEmergencyPetition(),
      ),

      // 12. NFSA PDS Ration Siphoning
      CivicCaseItem(
        caseNumber: 12,
        titleEn: 'NFSA 2013 PDS Foodgrain Siphoning & DGRO Statutory Petition',
        titleHi: 'खाद्य सुरक्षा कानून (एनएफएसए) राशन कालाबाजारी एवं डीजीआरओ अपील',
        statutoryAct: 'Section 15 of National Food Security Act 2013 (NFSA)',
        authorityEn: 'District Grievance Redressal Officer (DGRO) / ADM Civil Supplies',
        authorityHi: 'जिला शिकायत निवारण अधिकारी (डीजीआरओ) / एडीएम रसद',
        category: CivicMachineryCategory.socialWelfareAndSafety,
        summaryEn: 'Redresses biometric e-PoS denial, dealer diversion of wheat/rice, and secures food security allowances.',
        summaryHi: 'अंगूठा न लगने पर राशन न देने और कोटेदार द्वारा अनाज चोरी की वैधानिक जांच।',
        penaltyOrReliefEn: 'Hearing within 30 days + immediate grain delivery + Food Security Allowance',
        penaltyOrReliefHi: '30 दिन में सुनवाई + खाद्यान्न की तत्काल डिलीवरी + सुरक्षा भत्ता',
        petitionGenerator: () => const PdsRationDenialReport(
          rationCardNumber: 'NFSA-PHH-09148201',
          cardholderName: 'Shanti Devi',
          fairPriceShopNumber: 'FPS-DEALER-409',
          monthYear: 'October 2026',
          entitledWheatKg: 15.0,
          entitledRiceKg: 10.0,
          isPosMachineBiometricFailure: true,
          isDealerRefusingRation: true,
        ).generateDgroPetition(),
      ),

      // 13. NHM Hospital Drug Shortage & Absenteeism
      CivicCaseItem(
        caseNumber: 13,
        titleEn: 'National Health Mission Hospital Medicine Stockout & Doctor Absenteeism',
        titleHi: 'सरकारी अस्पताल/पीएचसी दवा कमी एवं डॉक्टर अनुपस्थिति शिकायत',
        statutoryAct: 'Indian Public Health Standards (IPHS) & Free Drug Service Initiative',
        authorityEn: 'Chief Medical Officer (CMO) / Mission Director (NHM)',
        authorityHi: 'मुख्य चिकित्सा अधिकारी (सीएमओ) / मिशन निदेशक (एनएचएम)',
        category: CivicMachineryCategory.socialWelfareAndSafety,
        summaryEn: 'Audits OPD doctor presence and enforces 100% vital medicine availability from warehouse.',
        summaryHi: 'ड्यूटी पर डॉक्टर की गैरहाजिरी और अस्पताल में जरूरी दवाओं के अभाव की शिकायत।',
        penaltyOrReliefEn: 'Immediate restocking within 24h + disciplinary salary deduction for truant doctors',
        penaltyOrReliefHi: '24 घंटे में दवा आपूर्ति + अनुपस्थित डॉक्टर पर अनुशासनात्मक कार्रवाई',
        petitionGenerator: () => const PublicHospitalAuditRecord(
          hospitalName: 'Primary Health Centre (PHC) Badarpur',
          wardOrDistrict: 'South East District',
          missingEssentialDrugName: 'Insulin, Oral Rehydration Salts & Anti-Hypertensive Amlodipine',
          isDoctorAbsentDuringOpdHours: true,
          opdTimingSlot: '9:00 AM - 1:00 PM',
        ).generateChiefMedicalOfficerPetition(),
      ),

      // 14. RTPS Delay & ACB 1064
      CivicCaseItem(
        caseNumber: 14,
        titleEn: 'Right to Public Services (RTPS) Delay & ACB 1064 Anti-Bribery Dossier',
        titleHi: 'लोक सेवा गारंटी अधिनियम में देरी एवं एंटी-करप्शन 1064 शिकायत',
        statutoryAct: 'Right to Guaranteed Delivery of Public Services Act & PC Act 1988',
        authorityEn: 'Appellate Authority (RTPS) & Anti-Corruption Bureau (Toll-Free 1064)',
        authorityHi: 'लोक सेवा गारंटी प्रथम अपीलीय प्राधिकारी एवं भ्रष्टाचार निरोधक ब्यूरो',
        category: CivicMachineryCategory.revenueAndTransparency,
        summaryEn: 'Demands ₹250/day compensation from truant clerks for overdue birth/caste certificates + secret bribery report.',
        summaryHi: 'प्रमाणपत्रों में देरी पर ₹250/दिन बाबू के वेतन से मुआवजा एवं रिश्वत की शिकायत।',
        penaltyOrReliefEn: '₹250/day statutory citizen compensation + confidential ACB trap registration',
        penaltyOrReliefHi: 'नागरिक को ₹250/दिन हर्जाना + भ्रष्टाचार निरोधक ब्यूरो द्वारा गोपनीय जांच',
        petitionGenerator: () => const ServiceDeliveryDelayAudit(
          serviceName: 'Municipal Birth Certificate (Registration of Births & Deaths)',
          applicationReferenceNumber: 'RTPS-BIRTH-2026-8812',
          citizenName: 'Deepak Varma',
          statutoryLimitDays: 7,
          actualElapsedDays: 24,
          hasBriberyDemand: true,
          briberyAmountDemanded: 1500.0,
        ).generateRtpsAndAcbPetition(),
      ),

      // 15. Vector Control DBC Fogging
      CivicCaseItem(
        caseNumber: 15,
        titleEn: 'Vector-Borne DBC Mosquito Larvae & Section 214 Fogging Requisition',
        titleHi: 'डेंगू/मलेरिया मच्छर लार्वा रोकथाम एवं फॉगिंग मांग',
        statutoryAct: 'Section 214 of Municipal Corporation Act (Mosquito-Genic Breeding)',
        authorityEn: 'District Malaria Officer / Domestic Breeding Checker (DBC) Head',
        authorityHi: 'जिला मलेरिया अधिकारी / नगर निगम स्वास्थ्य विभाग',
        category: CivicMachineryCategory.waterAndHealth,
        summaryEn: 'Deploys DBC teams with anti-larval chemical spray and vehicle-mounted thermal fogging at dusk.',
        summaryHi: 'शाम को गाड़ियों से कीटनाशक फॉगिंग और लार्वा नष्ट करने की दवा का छिड़काव।',
        penaltyOrReliefEn: 'Thermal fogging deployment within 24h + temephos larval extermination',
        penaltyOrReliefHi: '24 घंटे में फॉगिंग मशीन की तैनाती + एंटी-लार्वा छिड़काव',
        petitionGenerator: () => const VectorControlRequisition(
          wardName: 'Najafgarh Zone Ward 42',
          locality: 'Prem Nagar Extension & Ganda Nala Road',
          hasDengueMalariaCases: true,
          activePatientCount: 7,
          hasStagnantWaterBody: true,
          daysSinceLastFogging: 21,
        ).generateMalariaOfficerPetition(),
      ),

      // 16. CAQM GRAP Dust Control
      CivicCaseItem(
        caseNumber: 16,
        titleEn: 'CAQM Act & GRAP Stage-III/IV Construction Dust Enforcement',
        titleHi: 'वायु गुणवत्ता प्रबंधन (ग्रेप नियम) एवं निर्माण धूल प्रदूषण नियंत्रण',
        statutoryAct: 'Commission for Air Quality Management (CAQM) Act 2021 & GRAP Orders',
        authorityEn: 'Member Secretary, CAQM & State Pollution Control Board Dust Portal',
        authorityHi: 'वायु गुणवत्ता प्रबंधन आयोग एवं प्रदूषण नियंत्रण बोर्ड',
        category: CivicMachineryCategory.environmentAndAir,
        summaryEn: 'Stop-work notice for construction sites lacking green net screening, anti-smog guns, or water sprinklers.',
        summaryHi: 'धूल उड़ाने वाली निर्माणाधीन साइटों पर काम रुकवाने और 5 लाख जुर्माने का नोटिस।',
        penaltyOrReliefEn: 'Stop-work order + ₹5,00,000 Environmental Damage Compensation (EDC)',
        penaltyOrReliefHi: 'काम बंद करने का आदेश + ₹5,00,000 पर्यावरणीय क्षतिपूर्ति जुर्माना',
        petitionGenerator: () => const ConstructionDustPollutionReport(
          siteAddress: 'Commercial Tower Construction, Plot 4, Expressway Belt',
          builderOrContractorName: 'Skyline Landmark Developers',
          hasGreenSheetCovering: false,
          hasAntiSmogGunOperating: false,
          isUncoveredSandGravelStored: true,
          currentAqiZone: 'Very Poor (AQI 385 - GRAP Stage III Active)',
        ).generateCaqmPollutionPetition(),
      ),

      // 17. Horticulture Public Park Swings
      CivicCaseItem(
        caseNumber: 17,
        titleEn: 'Municipal Horticulture Public Park Rejuvenation & Swings Repair',
        titleHi: 'नगर निगम उद्यान विभाग: पार्क मरम्मत एवं बच्चों के झूले दुरुस्त',
        statutoryAct: 'Municipal Horticulture Maintenance Regulations & Child Safety Guidelines',
        authorityEn: 'Director / Deputy Director (Horticulture), Municipal Corporation',
        authorityHi: 'उद्यान निदेशक / उप निदेशक (बागवानी अनुभाग)',
        category: CivicMachineryCategory.roadsAndInfra,
        summaryEn: 'Repairs laceration hazards on broken swings, trims dangerous dead branches, and restores park lighting.',
        summaryHi: 'टूटे हुए झूलों की मरम्मत, खतरनाक सूखी डालों की छंटाई और पार्क में लाइट।',
        penaltyOrReliefEn: 'Play area repair under Urban Child Fund + 48h maintenance squad visit',
        penaltyOrReliefHi: '48 घंटे में रखरखाव टीम द्वारा झूलों की वेल्डिंग एवं सुरक्षा मरम्मत',
        petitionGenerator: () => const PublicParkConditionAudit(
          parkName: 'Mahatma Gandhi Smriti Children Park',
          wardName: 'Rajinder Nagar Ward 18',
          brokenChildrenSwingsCount: 4,
          hasOvergrownWildVegetation: true,
          hasDeadHazardousBranches: true,
          isLightingWorkingInPark: false,
        ).generateHorticultureDirectorPetition(),
      ),

      // 18. Water-Sewer Siphonage Biohazard
      CivicCaseItem(
        caseNumber: 18,
        titleEn: 'Critical Biohazard: Water-Sewer Siphonage Cross-Contamination Alert',
        titleHi: 'आपातकालीन जैव-खतरा: सीवर और पीने के पानी का पाइपलाइन रिसाव',
        statutoryAct: 'Disaster Management Act 2005 & National Water Policy Guidelines',
        authorityEn: 'Chief Engineer (Water Supply & Drainage Operations) & DM (DDMA)',
        authorityHi: 'मुख्य अभियंता (जल एवं सीवेज) एवं जिला आपदा प्रबंधन प्राधिकरण',
        category: CivicMachineryCategory.waterAndHealth,
        summaryEn: 'Emergency code red for black sewage entering drinking taps; shuts off valve and rushes 4 tankers in 90 mins.',
        summaryHi: 'पीने के पानी में सीवर मिलने पर मुख्य वाल्व बंद, 90 मिनट में टैंकर और चिकित्सा कैंप।',
        penaltyOrReliefEn: 'Immediate pipeline isolation + 4 free water tankers in 90m + medical outpost',
        penaltyOrReliefHi: '90 मिनट में 4 स्वच्छ पानी के टैंकर + ओआरएस और मेडिकल कैंप की तैनाती',
        petitionGenerator: () => const WaterSewerCrossContaminationAlert(
          locality: 'Brahmpuri Gali No. 4, Old Subzi Mandi',
          wardName: 'Seelampur',
          affectedHouseholdsCount: 85,
          hasGastroenteritisCases: true,
          estimatedLeakPoint: 'Junction of 8-inch CI Water Line and 450mm Brick Sewer Line',
        ).generateEmergencySiphonageProtocolNotice(),
      ),

      // 19. UBBL Unauthorized Construction
      CivicCaseItem(
        caseNumber: 19,
        titleEn: 'UBBL Building Bye-Laws Section 343 Unauthorized Construction Inquiry',
        titleHi: 'भवन निर्माण उपविधि (यूबीबीएल) धारा 343 अवैध निर्माण एवं सीलिंग',
        statutoryAct: 'Section 343 & 344 of Municipal Corporation Act & Unified Building Bye-Laws',
        authorityEn: 'Superintending Engineer (Building) / Zonal Deputy Commissioner',
        authorityHi: 'अधीक्षण अभियंता (भवन) / जोनल उपायुक्त',
        category: CivicMachineryCategory.revenueAndTransparency,
        summaryEn: 'Issues show-cause notice, halts utility connections, and initiates sealing for multi-storey deviations.',
        summaryHi: 'अवैध 5 मंजिला निर्माण, बिजली-पानी कनेक्शन काटने और सीलिंग का वैधानिक नोटिस।',
        penaltyOrReliefEn: 'Stop-work order under Sec 344 + disconnection of water/power + sealing order',
        penaltyOrReliefHi: 'धारा 344 में काम रुकवाना + बिजली-पानी काटना + सीलिंग की कार्रवाई',
        petitionGenerator: () => const BuildingViolationReport(
          propertyAddress: 'Property No. C-14, Main Road, Govindpuri',
          wardName: 'Kalkaji Zone',
          sanctionedFloors: 3,
          actualConstructedFloors: 6,
          isEncroachingPublicSetback: true,
          hasOngoingConstructionAtNight: true,
        ).generateSection343ShowCausePetition(),
      ),

      // 20. RTI First Appeal & State Lokayukta
      CivicCaseItem(
        caseNumber: 20,
        titleEn: 'Statutory First Appeal (RTI Section 19) & State Lokayukta Redressal',
        titleHi: 'आरटीआई प्रथम अपील (धारा 19) एवं लोकायुक्त भ्रष्टाचार निवारण',
        statutoryAct: 'Section 19(1) of Right to Information Act 2005 & State Lokayukta Act',
        authorityEn: 'First Appellate Authority (FAA) / Hon’ble Lokayukta',
        authorityHi: 'प्रथम अपीलीय प्राधिकारी (अपर आयुक्त) / माननीय लोकायुक्त',
        category: CivicMachineryCategory.revenueAndTransparency,
        summaryEn: 'Appeals deemed refusal after 30 days of PIO silence, securing free records and ₹25,000 officer penalty inquiry.',
        summaryHi: '30 दिन में जवाब न देने पर निःशुल्क जानकारी का आदेश और दोषी अधिकारी पर ₹25,000 जुर्माना।',
        penaltyOrReliefEn: 'Mandatory free disclosure under Sec 7(6) + ₹25,000 maximum penalty inquiry on PIO',
        penaltyOrReliefHi: 'धारा 7(6) में निःशुल्क सूचना + पीआईओ पर ₹25,000 तक का जुर्माना',
        petitionGenerator: () => StatutoryAppellateDossier(
          originalRtiApplicationNumber: 'RTI-MCD-2026-00419',
          departmentName: 'Engineering & Public Works Division',
          citizenName: 'Dr. Alok Nath Verma',
          rtiFilingDate: DateTime.now().subtract(const Duration(days: 38)),
          isPioCompletelySilentAfter30Days: true,
          substantiveCivicGrievanceSummary: 'Non-rectification of collapsed stormwater drain in Ward 4',
        ).generateFirstAppealPetition(),
      ),
    ];
  }
}
