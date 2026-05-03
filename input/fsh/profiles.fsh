Alias: $UCUM = http://unitsofmeasure.org
Alias: $LNC = http://loinc.org

RuleSet: GlucoseMassPerVolume
* value[x] only Quantity
* valueQuantity
  * code = #mg/dL
  * unit = "mg/dl"
  * ^short = "Glucose value in mg/dL"

RuleSet: GlucoseMolesPerVolume
* value[x] only Quantity
* valueQuantity
  * code = #mmol/L
  * unit = "mmol/l"
  * ^short = "Glucose value in mmol/L"

Profile: CGMSensorReading
Parent: Observation
Id: cgm-sensor-reading
Title: "CGM Sensor Reading"
Description: "A continuous glucose monitoring (CGM) sensor reading represented in either mg/dl or mmol/l."
* ^abstract = true
* effectiveDateTime 1..1 MS
  * ^short = "Time the measurement was taken"
// require that code is $LNC#99504-3 or $LNC#14745-4?
// require that value is either GlucoseMassPerVolume or GlucoseMolesPerVolume?

Profile: CGMSensorReadingMassPerVolume
Parent: CGMSensorReading
Id: cgm-sensor-reading-mass-per-volume
Title: "CGM Sensor Reading (Mass)"
Description: "A continuous glucose monitoring (CGM) sensor reading represented in mass units."
* insert GlucoseMassPerVolume
* code = $LNC#99504-3

Profile: CGMSensorReadingMolesPerVolume
Parent: CGMSensorReading
Id: cgm-sensor-reading-moles-per-volume
Title: "CGM Sensor Reading (Molar)"
Description: "A continuous glucose monitoring (CGM) sensor reading represented in molar units."
* insert GlucoseMolesPerVolume
* code = $LNC#14745-4

RuleSet: CGMSummaryBase
* code
  * ^short = "Type of CGM summary observation"
* effectivePeriod 1..1 MS
  * ^short = "Reporting period for the CGM summary."
  * start 1..1 MS
    * ^short = "Start date of the reporting period (YYYY-MM-DD)"
  * end 1..1 MS
    * ^short = "End date of the reporting period (YYYY-MM-DD)"

 
Profile: CGMSummaryObservation
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
Id: cgm-summary  
Title: "CGM Summary Observation"
Description: "An observation representing a summary of continuous glucose monitoring (CGM) data."
* code = CGMSummaryCodesTemporary#cgm-summary
  * ^short = "Code for Times in Ranges observation"
* effectivePeriod 1..1 MS
  * ^short = "Reporting period for the CGM summary"
  * start 1..1 MS
    * ^short = "Start date of the reporting period (YYYY-MM-DD)" 
  * end 1..1 MS
    * ^short = "End date of the reporting period (YYYY-MM-DD)"
* hasMember ^slicing.discriminator.type = #value
  * ^short = "Slicing based on the profile of the referenced resource"
* hasMember ^slicing.discriminator.path = "resolve().code"
  * ^short = "Path used to identify the slices"
* hasMember ^slicing.rules = #open
  * ^short = "Open slicing allowing additional slices"  
* hasMember 6..*
* hasMember contains
    meanGlucoseMassPerVolume 0..1 MS and
    meanGlucoseMolesPerVolume 0..1 MS and
    timesInRanges 1..1 MS and 
    gmi 1..1 MS and
    cv 1..1 MS and
    daysOfWear 1..1 MS and
    sensorActivePercentage 1..1 MS
  * ^short = "CGM summary observations"
* hasMember[meanGlucoseMassPerVolume] only Reference(CGMSummaryMeanGlucoseMassPerVolume)
  * ^short = "Mean Glucose (Mass) observation"
* hasMember[meanGlucoseMolesPerVolume] only Reference(CGMSummaryMeanGlucoseMolesPerVolume)
  * ^short = "Mean Glucose (Molar) observation" 
* hasMember[timesInRanges] only Reference(CGMSummaryTimesInRanges)
  * ^short = "Times in Ranges observation"
* hasMember[gmi] only Reference(CGMSummaryGMI)
  * ^short = "Glucose Management Indicator (GMI) observation"
* hasMember[cv] only Reference(CGMSummaryCoefficientOfVariation)
  * ^short = "Coefficient of Variation (CV) observation"
* hasMember[daysOfWear] only Reference(CGMSummaryDaysOfWear)
  * ^short = "Days of Wear observation"
* hasMember[sensorActivePercentage] only Reference(CGMSummarySensorActivePercentage)
  * ^short = "Sensor Active Percentage observation"

Profile: CGMSummaryPDF
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-diagnosticreport-lab
Id: cgm-summary-pdf
Title: "CGM Summary PDF Report"
Description: "A PDF report containing a summary of continuous glucose monitoring (CGM) data."
* code = CGMSummaryCodesTemporary#cgm-summary
  * ^short = "Code for CGM Summary report"
* effectivePeriod 1..1 MS
  * start 1..1 MS
    * ^short = "Start date of the reporting period (YYYY-MM-DD)"
  * end 1..1 MS
    * ^short = "End date of the reporting period (YYYY-MM-DD)"
* presentedForm 1..1 MS
  * ^short = "The PDF report content"
* presentedForm.contentType 1..1 MS
  * ^short = "Content type of the report (application/pdf)"
* presentedForm.data 1..1 MS
  * ^short = "Base64-encoded PDF report data"
* presentedForm.contentType = #application/pdf
  * ^short = "PDF content type"
* presentedForm.data 1..1 MS
* result ^slicing.discriminator.type = #value
  * ^short = "Slicing based on the pattern of the component.code"
* result ^slicing.discriminator.path = "resolve().code"
  * ^short = "Path used to identify the slices"
* result ^slicing.rules = #open
  * ^short = "Open slicing allowing additional slices"
* result contains
    cgmSummary 0..* MS
  * ^short = "CGM Summary observation"
* result[cgmSummary] only Reference(CGMSummaryObservation)
  * ^short = "CGM Summary observation"

Profile: CGMSummaryTimesInRanges
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
Id: cgm-summary-times-in-ranges
Title: "CGM Summary Times in Ranges"
Description: "An observation representing the times in various ranges from a continuous glucose monitoring (CGM) summary."
* insert CGMSummaryBase
* code = CGMSummaryCodesTemporary#times-in-ranges
  * ^short = "Code for Times in Ranges observation"
* component ^slicing.discriminator.type = #value
  * ^short = "Slicing based on the pattern of the component.code"
* component ^slicing.discriminator.path = "code"
  * ^short = "Path used to identify the slices"
* component ^slicing.rules = #open
  * ^short = "Open slicing allowing additional slices"
* component contains
    timeInVeryLow 1..1 MS and
    timeInLow 1..1 MS and 
    timeInTarget 1..1 MS and
    timeInHigh 1..1 MS and
    timeInVeryHigh 1..1 MS
  * ^short = "Components representing times in different ranges"
* component[timeInVeryLow]
  * code = CGMSummaryCodesTemporary#time-in-very-low
  * insert QuantityPercent
* component[timeInLow]  
  * code = CGMSummaryCodesTemporary#time-in-low
  * insert QuantityPercent
* component[timeInTarget]
  * code ^patternCodeableConcept.coding[0] = CGMSummaryCodesTemporary#time-in-target
  * code ^patternCodeableConcept.coding[1] = $LNC#97510-2
  * insert QuantityPercent
* component[timeInHigh]
  * code = CGMSummaryCodesTemporary#time-in-high    
  * insert QuantityPercent
* component[timeInVeryHigh]
  * code = CGMSummaryCodesTemporary#time-in-very-high
  * insert QuantityPercent
 
Instance: MeanGlucoseMassPerVolumeWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = CGMSummaryCodesTemporary#mean-glucose-mass-per-volume
* coding[+] =  $LNC#97507-8

Profile: CGMSummaryMeanGlucoseMassPerVolume
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
Id: cgm-summary-mean-glucose-mass-per-volume
Title: "Mean Glucose (Mass)"
Description: "The mean glucose value from a continuous glucose monitoring (CGM) summary, represented in mass units."
* insert CGMSummaryBase
* code = MeanGlucoseMassPerVolumeWithLoinc
  * ^short = "Code for Mean Glucose observation"
* insert GlucoseMassPerVolume


Profile: CGMSummaryMeanGlucoseMolesPerVolume
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
Id: cgm-summary-mean-glucose-moles-per-volume
Title: "Mean Glucose (Molar)"
Description: "The mean glucose value from a continuous glucose monitoring (CGM) summary, represented in molar units."
* insert CGMSummaryBase
* code = CGMSummaryCodesTemporary#mean-glucose-moles-per-volume
  * ^short = "Code for Mean Glucose observation"
* insert GlucoseMolesPerVolume

RuleSet: QuantityPercent
* value[x] only Quantity
* valueQuantity 1..1
  * unit = "%" (exactly)
    * ^short = "Percentage unit"
  * code = #"%" (exactly)
    * ^short = "Dimensionless UCUM code"
  * system = $UCUM (exactly)
    * ^short = "UCUM code system"
  * ^short = "Value as a percentage"

Instance: GMIWithLoinc
InstanceOf: CodeableConcept
Usage: #inline
* coding[+] = CGMSummaryCodesTemporary#gmi
* coding[+] = $LNC#97506-0

Profile: CGMSummaryGMI
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
Id: cgm-summary-gmi
Title: "Glucose Management Indicator (GMI)"
Description: "The Glucose Management Indicator (GMI) value from a continuous glucose monitoring (CGM) summary."
* insert CGMSummaryBase
* code = GMIWithLoinc
  * ^short = "Code for Glucose Management Indicator (GMI) observation"
* insert QuantityPercent

Profile: CGMSummaryCoefficientOfVariation
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
Id: cgm-summary-coefficient-of-variation
Title: "Coefficient of Variation (CV)"
Description: "The Coefficient of Variation (CV) value from a continuous glucose monitoring (CGM) summary."
* insert CGMSummaryBase
* code = CGMSummaryCodesTemporary#cv
  * ^short = "Code for Coefficient of Variation (CV) observation"
* insert QuantityPercent

Profile: CGMSummaryDaysOfWear
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
Id: cgm-summary-days-of-wear
Title: "Days of Wear"
Description: "The number of days the continuous glucose monitoring (CGM) device was worn during the reporting period."
* insert CGMSummaryBase
* code = CGMSummaryCodesTemporary#days-of-wear
  * ^short = "Code for Days of Wear observation"
* valueQuantity 1..1 MS
  * unit = "days" (exactly)
    * ^short = "Days unit"
  * code = #d
    * ^short = "UCUM code for days"
  * system = $UCUM (exactly)
    * ^short = "UCUM code system"
  * ^short = "Number of days the CGM device was worn"

Profile: CGMSummarySensorActivePercentage
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab
Id: cgm-summary-sensor-active-percentage
Title: "Sensor Active Percentage"
Description: "The percentage of time the continuous glucose monitoring (CGM) sensor was active during the reporting period."
* insert CGMSummaryBase
* code = CGMSummaryCodesTemporary#sensor-active-percentage
  * ^short = "Code for Sensor Active Percentage observation"
* insert QuantityPercent

Profile: CGMDevice
Parent: Device
Id: cgm-device
Title: "CGM Device"
Description: "A continuous glucose monitoring (CGM) device."
* deviceName ^slicing.rules = #open
* deviceName ^slicing.discriminator.type = #value
* deviceName ^slicing.discriminator.path = "type"
* deviceName contains
    cgmDeviceName 1..* MS
* deviceName[cgmDeviceName].name 1..1 MS
  * ^short = "User-friendly name of the CGM device"
* deviceName[cgmDeviceName].type = #user-friendly-name
  * ^short = "Type indicating a user-friendlyname"
* serialNumber 1..1 MS
  * ^short = "Serial number of the CGM device"
* identifier 1..* MS
  * ^short = "Identifiers for the CGM device"

CodeSystem: CGMCodes
Id: cgm
Title: "Codes for CGM"
Description: "Codes to identify content associated with this IG"
* ^caseSensitive = true
* ^experimental = false
* ^status = #active
* #cgm-data-submission-bundle "CGM Bundle"
* #cgm-data-submission-standing-order "CGM Submission Standing Order"

CodeSystem: CGMSummaryCodesTemporary
Id: cgm-summary-codes-temporary
Title: "CGM Summary Code System"
Description: "Temporary code system for CGM summary observations."
* ^caseSensitive = true
* ^experimental = false
* ^status = #active
* #cgm-summary "CGM Summary"
* #mean-glucose-mass-per-volume "Mean Glucose (Mass per Volume)"
* #mean-glucose-moles-per-volume "Mean Glucose (Moles per Volume)"
* #times-in-ranges "Times in Glucose Ranges"
* #time-in-very-low "Time in Very Low Range (%)"
* #time-in-low "Time in Low Range (%)"
* #time-in-target "Time in Target Range (%)"
* #time-in-high "Time in High Range (%)"
* #time-in-very-high "Time in Very High Range (%)" 
* #gmi "Glucose Management Indicator (GMI)"
* #cv "Coefficient of Variation (CV)"
* #days-of-wear "Days of Wear"
* #sensor-active-percentage "Sensor Active Percentage"

Instance: CGMSummaryToLoinc
InstanceOf: ConceptMap
Usage: #definition
Title: "Mapping from CGM Temporary Codes to LOINC"
Description: "Mapping concepts from the CGM Summary code system to LOINC codes."
* name  = "CGMSummaryToLoinc"
* experimental = false
* status = #draft
* group[+].source = Canonical(CGMSummaryCodesTemporary)
* group[=].target = $LNC
* group[=].element[+]
  * code = #mean-glucose-mass-per-volume
  * target[+].code = #97507-8
  * target[=].equivalence = #equivalent
* group[=].element[+]
  * code = #mean-glucose-moles-per-volume
* group[=].element[+]
  * code = #time-in-very-low
* group[=].element[+]
  * code = #time-in-low
* group[=].element[+]
  * code = #time-in-target
  * target[+].code = #97510-2
  * target[=].equivalence = #equivalent
* group[=].element[+]
  * code = #time-in-high
* group[=].element[+]
  * code = #time-in-very-high
* group[=].element[+]
  * code = #gmi
  * target[+].code = #97506-0
  * target[=].equivalence = #equivalent
* group[=].element[+]
  * code = #cv
* group[=].element[+]
  * code = #days-of-wear
* group[=].element[+]
  * code = #sensor-active-percentage


Profile: CGMDataSubmissionBundle
Parent: Bundle
Id: cgm-data-submission-bundle
Title: "CGM Data Submission Bundle"
Description: """
Once a Data Submitter is connected to the EHR, it can write data by submitting a `batch` Bundle to the EHR FHIR sever's `/` submission endpoint.
The submission bundle includes a `Bundle.meta.tag` value of `cgm-data-submission-bundle` to support ingestion workflows on servers with limited data ingestion capabilities. The tag has no impact on the meaning of the bundle, and can safely be ignored by servers that offer a general-purpose `POST /` endpoint.

The Bundle `entry` array includes any combination of 

* CGM Summary PDF Reports ([Profile](StructureDefinition-cgm-summary-pdf.html#profile), [Example](DiagnosticReport-cgmSummaryPDFExample.json.html#root))
* CGM Summary Observation ([Profile](StructureDefinition-cgm-summary.html#profile), [Example](Observation-cgmSummaryExample.json.html#root))
  * Mean Glucose (Mass per Volume) ([Profile](StructureDefinition-cgm-summary-mean-glucose-mass-per-volume.html#profile), [Example](Observation-cgmSummaryMeanGlucoseMassPerVolumeExample.json.html#root))
  * Mean Glucose (Moles per Volume) ([Profile](StructureDefinition-cgm-summary-mean-glucose-moles-per-volume.html#profile), [Example](Observation-cgmSummaryMeanGlucoseMolesPerVolumeExample.json.html#root))
  * Times in Ranges ([Profile](StructureDefinition-cgm-summary-times-in-ranges.html#profile), [Example](Observation-cgmSummaryTimesInRangesExample.json.html#root))
  * Glucose Management Index ([Profile](StructureDefinition-cgm-summary-gmi.html#profile), [Example](Observation-cgmSummaryGMIExample.json.html#root))
  * Coefficient of Variations ([Profile](StructureDefinition-cgm-summary-coefficient-of-variation.html#profile), [Example](Observation-cgmSummaryCoefficientOfVariationExample.json.html#root))
  * Sensor Days of Wear ([Profile](StructureDefinition-cgm-summary-days-of-wear.html#profile), [Example](Observation-cgmSummaryDaysOfWearExample.json.html#root))
  * Sensor Active Percentage ([Profile](StructureDefinition-cgm-summary-sensor-active-percentage.html#profile), [Example](Observation-cgmSummarySensorActivePercentageExample.json.html#root))
* CGM Devices ([Profile](StructureDefinition-cgm-device.html#profile), [Example](Device-cgmDeviceExample.json.html#root))
* CGM Sensor Readings (Mass per Volume) ([Profile](StructureDefinition-cgm-sensor-reading-mass-per-volume.html#profile), [Example](Observation-cgmSensorReadingMassPerVolumeExample.json.html#root))
* CGM Sensor Readings (Moles per Volume) ([Profile](StructureDefinition-cgm-sensor-reading-moles-per-volume.html#profile), [Example](Observation-cgmSensorReadingMolesPerVolumeExample.json.html#root))
"""


* meta.tag
  * ^slicing.discriminator.path = "$this"
  * ^slicing.discriminator.type = #value
  * ^slicing.rules = #open
* meta.tag contains cgmSubmissionBundle 1..1 MS
* meta.tag[cgmSubmissionBundle] = CGMCodes#cgm-data-submission-bundle
  * ^short = "Tag for CGM submission bundle"
* timestamp 1..1 MS
  * ^short = "Instant the bundle was created"
* entry ^slicing.discriminator[+].type = #type
* entry ^slicing.discriminator[=].path = "resource"
* entry ^slicing.discriminator[+].type = #value
* entry ^slicing.discriminator[=].path = "resource.ofType(Observation).code"
* entry ^slicing.rules = #open
* entry 1..* MS
* entry contains
    patient 0..1 MS and
    observation 0..* MS and
    diagnosticReport 0..* MS and
    device 0..* MS
* entry[patient].resource only us-core-patient
  * ^short = "Patient entry is a US Core Patient"
* entry[device].resource only CGMDevice
  * ^short = "CGM device entry must conform to CGMDevice profile"
* entry[diagnosticReport].resource only CGMSummaryPDF
  * ^short = "CGM summary PDF entry must conform to CGMSummaryPDF profile"
* entry[observation] contains
    cgmSummary 0..* MS and
    cgmSummaryMeanGlucoseMassPerVolume 0..* MS  and
    cgmSummaryMeanGlucoseMolesPerVolume 0..* MS and
    cgmSummaryTimesInRanges 0..* MS and
    cgmSummaryGMI 0..* MS and
    cgmSummaryCoefficientOfVariation 0..* MS and
    cgmSummaryDaysOfWear 0..* MS and
    cgmSummarySensorActivePercentage 0..* MS and
    device 0..* MS and
    cgmSensorReadingMassPerVolume 0..* MS and
    cgmSensorReadingMolesPerVolume 0..* MS
* entry[observation][cgmSummary].resource only CGMSummaryObservation
* entry[observation][cgmSummaryMeanGlucoseMassPerVolume].resource only CGMSummaryMeanGlucoseMassPerVolume
* entry[observation][cgmSummaryMeanGlucoseMolesPerVolume].resource only CGMSummaryMeanGlucoseMolesPerVolume
* entry[observation][cgmSummaryTimesInRanges].resource only CGMSummaryTimesInRanges
* entry[observation][cgmSummaryGMI].resource only CGMSummaryGMI
* entry[observation][cgmSummaryCoefficientOfVariation].resource only CGMSummaryCoefficientOfVariation
* entry[observation][cgmSummaryDaysOfWear].resource only CGMSummaryDaysOfWear
* entry[observation][cgmSummarySensorActivePercentage].resource only CGMSummarySensorActivePercentage
* entry[observation][cgmSensorReadingMassPerVolume].resource only CGMSensorReadingMassPerVolume
* entry[observation][cgmSensorReadingMolesPerVolume].resource only CGMSensorReadingMolesPerVolume

  
Profile: CGMDataSubmissionStandingOrder
Parent: http://hl7.org/fhir/us/core/StructureDefinition/us-core-servicerequest
Id: cgm-data-submission-standing-order
Title: "Data Submission Standing Order"
Description: """
The Data Receiver can expose a standing order indicating:

* How often a Data Submitter should submit CGM data
* What data a Data Submitter should include in each CGM Data Submission Bundle.


**Guiding Data Submission**

This standing order is modeled as a FHIR `ServiceRequest` resource, which 
Data Submitters can query to guide their future submissions. The standing order specifyies the patient, the type of data to be submitted, and the desired frequency of submission.

**DataSubmissionSchedule**

The `DataSubmissionSchedule` extension contains:

- `submissionFrequency` (1..1): A `Timing` element that specifies the frequency or schedule for data submission. It includes elements a `frequency`, `period`, `periodUnit`, and optionally `maxFrequency` define the desired submission schedule.

- `submissionDataProfile` (1..*): A list of `canonical` references to FHIR profiles that represent the types of data to be submitted according to the specified schedule.

Multiple `DataSubmissionSchedule` extensions can be included in a single `DataSubmissionRequest` resource if the Data Recipient prefers a different schedule for different data types.

It's important to note that submissions can also be **manually triggered by a patient or provider** within an app. For example, if there is an upcoming appointment, the provider can click a button to manually trigger submission of the most up-to-date results. Out-of-band communication between the app developer and the clinical provider system can also be used to establish preferred submission schedules.

"""
* intent = #order
* code = CGMCodes#cgm-data-submission-standing-order
  * ^short = "Code for CGM submission standing order"
* subject 1..1
  * ^short = "Patient for the submission order"
* extension contains 
    DataSubmissionSchedule named dataSubmissionSchedule 0..*
  * ^short = "Schedules for data submission"

Extension: DataSubmissionSchedule
Id: data-submission-schedule
Title: "Data Submission Schedule"
Description: "Schedule and type of data to be submitted"
Context: ServiceRequest
* extension contains
    submissionFrequency 1..1 MS and
    submissionDataProfile 1..*  MS
  * ^short = "Submission frequency and data profiles"
* extension[submissionFrequency].value[x] only Timing
  * ^short = "Timing for data submission"
* extension[submissionFrequency].valueTiming.repeat.frequency 1..1 MS
  * ^short = "Intended frequency of submission"
* extension[submissionFrequency].valueTiming.repeat.frequencyMax 0..1 MS
  * ^short = "Maximum frequency of submission"
* extension[submissionFrequency].valueTiming.repeat.period 1..1 MS
  * ^short = "Period for submission frequency" 
* extension[submissionFrequency].valueTiming.repeat.periodUnit 1..1 MS
  * ^short = "Unit for the period (typically d, wk, or mo)"
* extension[submissionDataProfile].value[x] only canonical
* extension[submissionDataProfile].valueCanonical 1..1 MS
  * ^short = "Data profile for submission"
