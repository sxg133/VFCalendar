/**
*	Test for calendar display controller
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
@isTest
private class CalendarDisplayControllerTest {

	static Date copyDate(Date d) {
		return Date.newInstance(d.year(), d.month(), d.day());
	}

	@isTest static void testCalendarDisplayController() {

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

		CalendarTestHelper.StandardEventRetriever calItemRetriever = new CalendarTestHelper.StandardEventRetriever();
		CalendarHandler calHandler;

		CalendarDisplayController cdc;
		Test.startTest();
			cdc = new CalendarDisplayController();
			calHandler = new CalendarHandler(calItemRetriever);
			calHandler.setDate(e1.StartDateTime.date());
			cdc.CalHandler = calHandler;

			system.assertEquals(null, cdc.SelectedCalendarItem, 'The selected calendar item should be null if no ID is set.');
			cdc.SelectedCalendarItemId = e1.Id;
			system.assertEquals(e1.Id, cdc.SelectedCalendarItem.ItemId, 'Could not retrieve the appropriate calendar item.');

			cdc.goToToday();
			system.assertEquals(Date.today(), calHandler.ActiveDate, 'The current date was not set in the calendar handler.');

			Date selDate = Date.newInstance(2014, 3, 5);
			cdc.SelectedDate = selDate;
			system.assertEquals(cdc.SelectedDate, calHandler.ActiveDate, 'The Selected Date property did not set the calendar handler date.');
			selDate = Date.newInstance(2014, 3, 4);
			calHandler.setDate(selDate);
			system.assertEquals(calHandler.ActiveDate, cdc.SelectedDate, 'Setting the calendar handler date did not update the Selected Date property.');

			// coverage
			cdc.setSelectedCalendarItem();
		Test.stopTest();
	}

	@isTest static void testUnitNavigation() {

		CalendarTestHelper.StandardEventRetriever calItemRetriever = new CalendarTestHelper.StandardEventRetriever();
		CalendarHandler calHandler;

		Date startDate = Date.newInstance(2014, 3, 26);

		CalendarDisplayController cdc;
		Test.startTest();
			cdc = new CalendarDisplayController();
			calHandler = new CalendarHandler(calItemRetriever);
			calHandler.setDate(startDate);
			cdc.CalHandler = calHandler;
			cdc.CalParams = new CalendarParameters();

			// week
			cdc.ViewSelection = 'WEEK';
			cdc.changeView();

			Date nextWeek = calHandler.ActiveDate.addDays(7);
			cdc.goToNextUnit();
			system.assertEquals(nextWeek, calHandler.ActiveDate, 'The calendar handler was not navigated to the next week.');

			Date prevWeek = calHandler.ActiveDate.addDays(-7);
			cdc.goToPreviousUnit();
			system.assertEquals(prevWeek, calHandler.ActiveDate, 'The calendar handler was not navigated to the previous week.');

			Date nextMonth = calHandler.ActiveDate.addMonths(1);
			cdc.goToNextBigUnit();
			system.assertEquals(nextMonth, calHandler.ActiveDate, 'The calendar handler was not navigated to the next month.');

			Date prevMonth = calHandler.ActiveDate.addMonths(-1);
			cdc.goToPreviousBigUnit();
			system.assertEquals(prevMonth, calHandler.ActiveDate, 'The calendar handler was not navigated to the previous month.');

			// month
			cdc.ViewSelection = 'MONTH';
			cdc.changeView();

			nextMonth = calHandler.ActiveDate.addMonths(1);
			cdc.goToNextUnit();
			system.assertEquals(nextMonth, calHandler.ActiveDate, 'The calendar handler was not navigated to the next month.');

			prevMonth = calHandler.ActiveDate.addMonths(-1);
			cdc.goToPreviousUnit();
			system.assertEquals(prevMonth, calHandler.ActiveDate, 'The calendar handler was not navigated to the previous month.');

			Date nextYear = calHandler.ActiveDate.addYears(1);
			cdc.goToNextBigUnit();
			system.assertEquals(nextYear, calHandler.ActiveDate, 'The calendar handler was not navigated to the next year.');

			Date prevYear = calHandler.ActiveDate.addYears(-1);
			cdc.goToPreviousBigUnit();
			system.assertEquals(prevYear, calHandler.ActiveDate, 'The calendar handler was not navigated to the previous year.');

		Test.stopTest();
	}

	@isTest static void testCalendarProperties() {
		CalendarParameters cp;
		Test.startTest();
			cp = new CalendarParameters();

			system.assert(cp.ShowNavigation, 'The default for show navigation should be true.');
			system.assert(cp.ShowHeader, 'The default for show header should be true.');
			system.assert(cp.ShowViewSelect, 'The default for show view select should be true.');
			system.assert(cp.ShowCalendarItemPopup, 'The default for show item popup should be true.');
			system.assertEquals(
				CalendarParameters.CalendarView.MONTH, 
				cp.SelectedView,
				'The default for the calendar view should be \'Month\''
				);
			system.assertEquals('MONTH', cp.SelectedViewName, 'The default view name should be \'Month\'');

			cp.SelectedViewName = 'WEEK';
			system.assertEquals(
				CalendarParameters.CalendarView.WEEK, 
				cp.SelectedView, 
				'The selected view should be WEEK after setting the name.'
				);

			try {
				cp.SelectedViewName = 'INVALID VIEW';
				system.assert(false, 'An exception should be thrown when an invalid view name is set.');
			} catch (CalendarException ex) {
				system.assert(true);
			}

		Test.stopTest();
	}
}