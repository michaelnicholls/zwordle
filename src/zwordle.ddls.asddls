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
       @UI.lineItem: [{ position:  10 }]
 
  char1 : abap.char(1);
       @UI.lineItem: [{ position:  20 }]
 
  char2 : abap.char(1);
       @UI.lineItem: [{ position:  30 }]
 
  char3 : abap.char(1);
       @UI.lineItem: [{ position:  40 }]
 
  cha41 : abap.char(1);
       @UI.lineItem: [{ position:  50 }]
 
  char5 : abap.char(1);
       @UI.lineItem: [{ position:  60 }]
 text : abap.char(40);
  
}
