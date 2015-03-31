/**
*	Test for calendar item class
*
*	@author	Sahil Grover 
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
			calItem.StartDateTime = DateTime.now();
			calItem.EndDateTime = calItem.StartDateTime.addHours(1);
			String endDateTime = calItem.FormattedEndDateTime;
			String endDate = calItem.FormattedEndDate;
			String endTime = calItem.FormattedEndTime;
			String startDateTime = calItem.FormattedStartDateTime;
			String startDate = calItem.FormattedStartDate;
			String startTime = calItem.FormattedStartTime;
		Test.stopTest();
		system.assertEquals('/FAKEID', calItem.DetailUrl);
	}

	@isTest static void testSort() {
		CalendarItem calItem1 = new CalendarItem('FAKE1');
		CalendarItem calItem2 = new CalendarItem('FAKE2');
		CalendarItem calItem3 = new CalendarItem('FAKE3');
		calItem1.StartDate = Date.today();
		calItem2.StartDate = calItem1.StartDate.addDays(4);
		calItem3.StartDate = calItem1.StartDate.addDays(-4);

		List<CalendarItem> calItems = new List<CalendarItem>{calItem2, calItem3, calItem1};

		Test.startTest();
			calItems.sort();
		Test.stopTest();

		system.assertEquals('FAKE3', calItems[0].ItemId, 'The calendar item list did not sort properly.');
		system.assertEquals('FAKE1', calItems[1].ItemId, 'The calendar item list did not sort properly.');
		system.assertEquals('FAKE2', calItems[2].ItemId, 'The calendar item list did not sort properly.');
	}
	
}