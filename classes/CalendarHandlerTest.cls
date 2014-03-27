/**
*	Test class for the calendar handler
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
@isTest
private class CalendarHandlerTest {

	@isTest static void testNoEvents() {
		CalendarTestHelper.CalendarItemRetriever calItemRetriever = new CalendarTestHelper.CalendarItemRetriever();
		CalendarHandler calHandler;
		Test.startTest();
			calHandler = new CalendarHandler(calItemRetriever);
			system.assertEquals(0, calHandler.Items.size(), 'No events should be retrieved since none were created.');
			try {
				calHandler.getCalendarItem('');
				system.assert(false, 'Find event by ID did not throw calendar exception as expected.');
			} catch (CalendarException ex) {
				system.assert(true);
			}
		Test.stopTest();
	}

	@isTest static void testNavigation() {
		CalendarTestHelper.CalendarItemRetriever calItemRetriever = new CalendarTestHelper.CalendarItemRetriever();
		CalendarHandler calHandler;
		Date activeDate = Date.newInstance(2014, 2, 17);
		Test.startTest();
			calHandler = new CalendarHandler(calItemRetriever, activeDate);
			// start of week
			system.assertEquals(
				Date.newInstance(2014, 2, 16),
				calHandler.StartOfWeek,
				'The start of the active date week is incorrect'
				);
			// end of week
			system.assertEquals(
				Date.newInstance(2014, 2, 22),
				calHandler.EndOfWeek,
				'The end of the active date week is incorrect'
				);
			// start of month
			system.assertEquals(
				Date.newInstance(2014, 2, 1),
				calHandler.StartOfMonth,
				'The start of the active date month is incorrect'
				);
			// end of month
			system.assertEquals(
				Date.newInstance(2014, 2, 28),
				calHandler.EndOfMonth,
				'The end of the active date month is incorrect'
				);

			// navigate
			// add years
			calHandler.goToNextYear();
			system.assertEquals(
				Date.newInstance(2015, 2, 17),
				calHandler.ActiveDate,
				'Failed to add years.'
				);
			// subtract years
			calHandler.goToPreviousYear();
			system.assertEquals(
				Date.newInstance(2014, 2, 17),
				calHandler.ActiveDate,
				'Failed to subtract years.'
				);
			// add months
			calHandler.goToNextMonth();
			system.assertEquals(
				Date.newInstance(2014, 3, 17),
				calHandler.ActiveDate,
				'Failed to add months.'
				);
			// subtract months
			calHandler.goToPreviousMonth();
			system.assertEquals(
				Date.newInstance(2014, 2, 17),
				calHandler.ActiveDate,
				'Failed to subtract months.'
				);
			// add weeks
			calHandler.goToNextWeek();
			system.assertEquals(
				Date.newInstance(2014, 2, 24),
				calHandler.ActiveDate,
				'Failed to add weeks.'
				);
			// subtract weeks
			calHandler.goToPreviousWeek();
			system.assertEquals(
				Date.newInstance(2014, 2, 17),
				calHandler.ActiveDate,
				'Failed to subtract weeks.'
				);
			// add days
			calHandler.goToNextDay();
			system.assertEquals(
				Date.newInstance(2014, 2, 18),
				calHandler.ActiveDate,
				'Failed to add days.'
				);
			// subtract days
			calHandler.goToPreviousDay();
			system.assertEquals(
				Date.newInstance(2014, 2, 17),
				calHandler.ActiveDate,
				'Failed to subtract days.'
				);

			system.assertEquals(7, calHandler.WeekdayNames.size(), 'Incorrect number of weekday names.');

			system.assertEquals(2, calHandler.DayOfWeek, 'Incorrect day of week for active date.');
			system.assertEquals('Monday', calHandler.Weekday, 'Incorrect weekday name for active date.');

			calHandler.setDate( Date.newInstance(2014, 3, 1) );
			system.assertEquals(1, calHandler.WeekOfMonth, 'The week number of the month for the active date is incorrect.');

		Test.stopTest();
	}

	@isTest static void testMultipleEvents() {

		DateTime startDateTime = DateTime.newInstance(
			Date.newInstance(2014, 02, 17),
			Time.newInstance(13, 30, 0, 0)
			);
		DateTime endDateTime = startDateTime.addHours(1);
		Event e1 = CalendarTestHelper.createEvent(startDateTime, endDateTime, 'Event 1');

		startDateTime = DateTime.newInstance(
			Date.newInstance(2014, 03, 17),
			Time.newInstance(13, 30, 0, 0)
			);
		endDateTime = startDateTime.addHours(1);
		Event e2 = CalendarTestHelper.createEvent(startDateTime, endDateTime, 'Event 2');

		insert new List<Event>{e1, e2};

		CalendarTestHelper.CalendarItemRetriever calItemRetriever = new CalendarTestHelper.CalendarItemRetriever();
		CalendarHandler calHandler;
		Test.startTest();
			calHandler = new CalendarHandler(calItemRetriever);

			// test event 1
			calHandler.setDate(e1.StartDateTime.date());
			system.assertEquals(
				1, 
				calHandler.Items.size(), 
				'Unexpected number of calendar items stored by the handler.'
				);
			system.assertEquals(
				5, 
				calHandler.Weeks.size(), 
				'Unexpected number of weeks in the calendar month for active date: ' + calHandler.ActiveDate
				);
			system.assertEquals(
				1, 
				calHandler.Weeks[3].Items.size(),
				'Unexpected number of calendar items in the week for active date: ' + calHandler.ActiveDate
				);
			system.assertEquals(
				1, 
				calHandler.Weeks[3].Days[1].Items.size(),
				'Unexpected number of calendar items in the day for active date: ' + calHandler.ActiveDate
				);

			// test event 2
			calHandler.setDate(e2.StartDateTime.date());
			system.assertEquals(
				1, 
				calHandler.Items.size(), 
				'Unexpected number of calendar items stored by the handler.'
				);
			system.assertEquals(
				6, 
				calHandler.Weeks.size(), 
				'Unexpected number of weeks in the calendar month for active date: ' + calHandler.ActiveDate
				);
			system.assertEquals(
				1, 
				calHandler.Weeks[3].Items.size(),
				'Unexpected number of calendar items in the week for active date: ' + calHandler.ActiveDate
				);
			system.assertEquals(
				1, 
				calHandler.Weeks[3].Days[1].Items.size(),
				'Unexpected number of calendar items in the day for active date: ' + calHandler.ActiveDate
				);

			// get calendar item
			CalendarItem calItem = calHandler.getCalendarItem(e2.Id);
			system.assertEquals(e2.Subject, calItem.Name);
		Test.stopTest();
	}

	@isTest static void testItemsAcrossMultipleDays() {

		DateTime startDateTime = DateTime.newInstance(
			Date.newInstance(2014, 03, 17),
			Time.newInstance(13, 30, 0, 0)
			);
		DateTime endDateTime = startDateTime.addDays(2);
		Event e1 = CalendarTestHelper.createEvent(startDateTime, endDateTime, 'Event 1');

		startDateTime = DateTime.newInstance(
			Date.newInstance(2014, 03, 20),
			Time.newInstance(13, 30, 0, 0)
			);
		endDateTime = startDateTime.addDays(2);
		Event e2 = CalendarTestHelper.createEvent(startDateTime, endDateTime, 'Event 2');
		e2.IsAllDayEvent = true;

		insert new List<Event>{e1, e2};

		CalendarTestHelper.CalendarItemRetriever calItemRetriever = new CalendarTestHelper.CalendarItemRetriever();
		CalendarHandler calHandler;
		Test.startTest();
			calHandler = new CalendarHandler(calItemRetriever);
			calHandler.setDate(e1.StartDateTime.date());
		Test.stopTest();

		system.assertEquals(6, calHandler.Items.size(), 'The calendar items were not split correctly.');

		Date startDate = e1.StartDateTime.date();
		for (integer i=0; i<3; i++) {

			system.assertEquals(
				e1.Id, 
				calHandler.Items[i].ItemId, 
				'The first three calendar Items should have the same ID as event 1.'
				);

			system.assertEquals(
				startDate, 
				calhandler.Items[i].StartDate, 
				'Calendar item ' + i + ' has an incorrect start date.'
				);

			startDate = startDate.addDays(1);
		}

		system.assertEquals(
			e1.StartDateTime.date(), 
			calHandler.Items[0].StartDate, 
			'The first calendar item should have the same start date as event 1.'
			);

		system.assertEquals(
			e1.EndDateTime.date(), 
			calHandler.Items[2].EndDate, 
			'The third calendar item should have the same end date as event 1'
			);
	}
}