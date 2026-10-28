@EndUserText.label: 'wordle'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_WORDLE'
define custom entity zwordle
{
  key line : abap.int4;
  @UI.selectionField: [{position: 20}]
  @EndUserText.label: 'Select a new target?'
  newword : flag;
  @UI.selectionField: [{ position:  10 }]
  @EndUserText.label: 'Guesses'
  guesses : abap.char( 5 );
       @UI.lineItem: [{ position:  10, criticality: 'crit1' }]
 
  char1 : abap.char(1);
       @UI.lineItem: [{ position:  20, criticality : 'crit2' }]
 
  char2 : abap.char(1);
       @UI.lineItem: [{ position:  30 , criticality: 'crit3'}]
 
  char3 : abap.char(1);
       @UI.lineItem: [{ position:  40, criticality: 'crit4' }]
 
  char4 : abap.char(1);
       @UI.lineItem: [{ position:  50, criticality: 'crit5' }]
 
  char5 : abap.char(1);
       @UI.lineItem: [{ position:  60 }]
 text : abap.char(40);
 @UI.hidden: true
  crit1: abap.int1;
 @UI.hidden: true
  crit2: abap.int1;
 @UI.hidden: true
  crit3: abap.int1;
 @UI.hidden: true
  crit4 : abap.int1;
 @UI.hidden: true
  crit5 : abap.int1;
  
}
