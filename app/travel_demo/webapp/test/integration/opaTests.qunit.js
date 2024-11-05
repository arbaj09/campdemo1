sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'traveldemo/test/integration/FirstJourney',
		'traveldemo/test/integration/pages/TravelList',
		'traveldemo/test/integration/pages/TravelObjectPage',
		'traveldemo/test/integration/pages/BookingObjectPage'
    ],
    function(JourneyRunner, opaJourney, TravelList, TravelObjectPage, BookingObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('traveldemo') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheTravelList: TravelList,
					onTheTravelObjectPage: TravelObjectPage,
					onTheBookingObjectPage: BookingObjectPage
                }
            },
            opaJourney.run
        );
    }
);