using TravelService from '../../srv/travel_service';
using from './annotations';


//
// annotations that control the behavior of fields and actions
//

// Workarounds for overly strict OData libs and clients
annotate cds.UUID with @Core.Computed  @(
    odata.Type : 'Edm.String',
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TravelStatus_code',
            Target : '@UI.DataPoint#TravelStatus_code',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TotalPrice',
            Target : '@UI.DataPoint#TotalPrice',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TotalPrice1',
            Target : '@UI.DataPoint#progress',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TravelStatus_code1',
            Target : '@UI.DataPoint#TravelStatus_code1',
        },
    ],
    UI.DataPoint #TravelStatus_code1 : {
        $Type : 'UI.DataPointType',
        Value : TravelStatus_code,
        Title : 'TravelStatus_code',
    },
    UI.FieldGroup #TravelData : {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : TravelID,
            },
            {
                $Type : 'UI.DataField',
                Value : to_Agency_AgencyID,
            },
            {
                $Type : 'UI.DataField',
                Value : to_Customer_CustomerID,
            },
            {
                $Type : 'UI.DataField',
                Value : Description,
            },
            {
                $Type : 'UI.DataField',
                Value : BeginDate,
                ![@UI.Hidden] : TravelStatus.cancelRestrictions,
            },
            {
                $Type : 'UI.DataField',
                Value : EndDate,
                ![@UI.Hidden] : TravelStatus.cancelRestrictions,
            },
            {
                $Type : 'UI.DataField',
                Value : CurrencyCode.name,
            },
        ],
    },
);

annotate TravelService.Travel with @(Common.SideEffects: {
  SourceProperties: [BookingFee],
  TargetProperties: ['TotalPrice']
}){
  BookingFee  @Common.FieldControl  : TravelStatus.fieldControl;
  BeginDate   @Common.FieldControl  : TravelStatus.fieldControl;
  EndDate     @Common.FieldControl  : TravelStatus.fieldControl;
  to_Agency   @Common.FieldControl  : TravelStatus.fieldControl;
  to_Customer @Common.FieldControl  : TravelStatus.fieldControl;

} actions {
  rejectTravel @(
    Core.OperationAvailable : { $edmJson: { $Ne: [{ $Path: 'in/TravelStatus_code'}, 'X']}},
    Common.SideEffects.TargetProperties : ['in/TravelStatus_code'],
  );
  acceptTravel @(
    Core.OperationAvailable : { $edmJson: { $Ne: [{ $Path: 'in/TravelStatus_code'}, 'A']}},
    Common.SideEffects.TargetProperties : ['in/TravelStatus_code'],
  );
  deductDiscount @(
    Core.OperationAvailable : { $edmJson: { $Eq: [{ $Path: 'in/TravelStatus_code'}, 'O']}}
  );
}

annotate TravelService.Travel @(
    Common.SideEffects#ReactonItemCreationOrDeletion : {
        SourceEntities : [
            to_Booking
        ],
       TargetProperties : [
           'TotalPrice'
       ]
    }
);

annotate TravelService.Booking with @UI.CreateHidden : to_Travel.TravelStatus.createDeleteHidden;
annotate TravelService.Booking with @UI.DeleteHidden : to_Travel.TravelStatus.createDeleteHidden;

annotate TravelService.Booking {
  BookingDate   @Core.Computed;
  ConnectionID  @Common.FieldControl  : to_Travel.TravelStatus.fieldControl;
  FlightDate    @Common.FieldControl  : to_Travel.TravelStatus.fieldControl;
  FlightPrice   @Common.FieldControl  : to_Travel.TravelStatus.fieldControl;
  BookingStatus @Common.FieldControl  : to_Travel.TravelStatus.fieldControl;
  to_Carrier    @Common.FieldControl  : to_Travel.TravelStatus.fieldControl;
  to_Customer   @Common.FieldControl  : to_Travel.TravelStatus.fieldControl;
};

annotate TravelService.Booking with @(
  Capabilities.NavigationRestrictions : {
    RestrictedProperties : [
      {
        NavigationProperty : to_BookSupplement,
        InsertRestrictions : {
          Insertable : to_Travel.TravelStatus.insertDeleteRestriction
        },
        DeleteRestrictions : {
          Deletable : to_Travel.TravelStatus.insertDeleteRestriction
        }
      }
    ]
  }
);


annotate TravelService.BookingSupplement {
  Price         @Common.FieldControl  : to_Travel.TravelStatus.fieldControl;
  to_Supplement @Common.FieldControl  : to_Travel.TravelStatus.fieldControl;
  to_Booking    @Common.FieldControl  : to_Travel.TravelStatus.fieldControl;
  to_Travel     @Common.FieldControl  : to_Travel.TravelStatus.fieldControl;

};

annotate Currency with @Common.UnitSpecificScale : Decimals;
