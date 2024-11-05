sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'traveldemo',
            componentId: 'BookingObjectPage',
            contextPath: '/Travel/to_Booking'
        },
        CustomPageDefinitions
    );
});