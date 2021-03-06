describe QME::Importer::Measure::TobaccoUseScreening do
  it "should import the the information relevant to determining tobacco use" do
    doc = Nokogiri::XML(File.new('fixtures/c32_fragments/0028/numerator.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    patient = {}
    
    raw_measure_json = File.read('measures/0028/components/root.json')
    measure_json = JSON.parse(raw_measure_json)
    
    tobacco_use = QME::Importer::Measure::TobaccoUseScreening.new(measure_json)
    measure_info = tobacco_use.parse(doc)
    
    measure_info['individual_counseling_encounter'].should == 1270598400
    measure_info['tobacco_user'].should == 1262304000
    measure_info['cessation_agent'].should == 1248825600
    measure_info['cessation_counseling'].should == 1252454400
    
  end
end