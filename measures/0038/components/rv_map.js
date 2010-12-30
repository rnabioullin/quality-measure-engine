function () {
  var patient = this;
  var measure = patient.measures["0038"];
  if (measure==null)
    measure={};

  var year = 365 * 24 * 60 * 60;
  var effective_date =  <%= effective_date %>;
  var earliest_birthdate =  effective_date - 2 * year;
  var latest_birthdate =    effective_date - 1 * year;

  // RV vaccines are considered when they are occurring < 2 years after 
  // the patients' birthdate
  var latest_rv_vaccine = patient.birthdate + 2 * year;

  var population = function() {
    return inRange(patient.birthdate, earliest_birthdate, latest_birthdate);
  }

  // the denominator logic is the same for all of the 0038 reports and this 
  // code is defined in the shared library in the project in the code from 
  // /js/childhood_immunizations.js
  var denominator = function() {
    return has_outpatient_encounter_with_pcp_obgyn(measure, patient.birthdate, effective_date);
  }

  var numerator = function() {
    number_rv_vaccine_administered = inRange(measure.rotavirus_vaccine_administered,
                                             patient.birthdate,
                                             latest_rv_vaccine);

    // To meet the criteria for this report, the patient needs to have either:
    // 2 Rotavirus (RV) vaccines up until the time that they are 2 years old
    // AND cannot have Medication allergy to RV vaccine
    return ((number_rv_vaccine_administered >= 2)
            &&
            !(inRange(measure.rotavirus_vaccine_allergy, patient.birthdate, effective_date)));
  }

  // no exclusions defined for any reports that are a part of NQF 0038
  var exclusion = function() {
    return false;
  }

  map(patient, population, denominator, numerator, exclusion);
};