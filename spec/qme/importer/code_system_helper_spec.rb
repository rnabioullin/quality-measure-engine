describe QME::Importer::CodeSystemHelper do
  before do
    raw_measure_json = File.read('measures/0043/0043_NQF_Pneumonia_Vaccination_Status_For_Older_Adults.json')
    @measure_json = JSON.parse(raw_measure_json)
  end
  
  it 'should be able to tell when a code is in a set from a property' do
    QME::Importer::CodeSystemHelper.is_in_code_list?('2.16.840.1.113883.6.88', '854931', 'vaccination', @measure_json).should be true
  end
  
  it 'should be able to tell when a code is in a set from a code list' do
    QME::Importer::CodeSystemHelper.is_in_codes?('2.16.840.1.113883.6.88', '854931', @measure_json['measure']['vaccination']['codes']).should be true
  end
  
  it 'should be able to tell when a code not is in a set' do
    QME::Importer::CodeSystemHelper.is_in_code_list?('2.16.840.1.113883.6.88', '23423', 'vaccination', @measure_json).should be false
  end
end