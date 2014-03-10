/**
*	Test for calendar item class
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
@isTest
private class CalendarItemTest {
	
	@isTest static void testDateSetting() {
		CalendarItem calItem;
		Test.startTest();
			calItem = new CalendarItem('FAKEID');

			// auto date time sets
			calItem.StartDate = Date.today();
			system.assertEquals(calItem.StartDate, calItem.StartDateTime.date());
			calItem.EndDate = Date.today();
			system.assertEquals(calItem.EndDate, calItem.EndDateTime.date());

			// auto date sets
			calItem.StartDateTime = DateTime.now();
			system.assertEquals(
				calItem.StartDateTime.date(), 
				calItem.StartDate, 
				'The start date was not set correctly following a start date time set.'
				);
			calItem.EndDateTime = DateTime.now();
			system.assertEquals(
				calItem.EndDateTime.date(), 
				calItem.EndDate,
				'The end date was not set correctly following a end date time set.'
			);
		Test.stopTest();
	}

	@isTest static void testDurationCalculations() {
		CalendarItem calItem;
		Test.startTest();
			calItem = new CalendarItem('FAKEID');

			// test exception
			try {
				double minutes = calItem.DurationInMinutes;
				system.assert(false, 'Failed to throw exception when trying to calculate duration without start and end times.');
			} catch (CalendarException ex) {
				system.assert(true);
			}

			// test all day
			calItem.IsAllDay = true;
			system.assertEquals(
				24 * 60, 
				calItem.DurationInMinutes, 
				'The duration in minutes is not correct for an all day event.'
				);
			system.assertEquals(
				(24 * 60) / 30 * 100, 
				calItem.DurationPercent, 
				'The duration as a percent of a half hour block is not correct for an all day event'
				);

			// test half hour
			calItem.IsAllDay = false;
			calItem.StartDateTime = DateTime.now();
			calItem.EndDateTime = calItem.StartDateTime.addMinutes(30);
			system.assertEquals(
				30, 
				calItem.DurationInMinutes,
				'The duration in minutes was not calculated correctly for a half hour.'
				);
			system.assertEquals(
				100,
				calItem.DurationPercent,
				'The duration as a percent of a half hour block was not calculated correctly for a half hour.'
				);

		Test.stopTest();
	}

	@isTest static void testProperties() {
		CalendarItem calItem;
		Test.startTest();
			calItem = new CalendarItem('FAKEID');
			// coverage for properties
			calItem.CssClass = 'fakecss';
		Test.stopTest();
		system.assertEquals('/FAKEID', calItem.DetailUrl);
	}
	
}