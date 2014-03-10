/**
*	Test class for the calendar handler
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
@isTest
private class CalendarHandlerTest {
	
	static Event createEvent(DateTime startDateTime, DateTime endDateTime, string subject) {
		Event e = new Event();
		e.StartDateTime = startDateTime;
		e.EndDateTime = endDateTime;
		e.Subject = subject;
		return e;
	}

	@isTest static void testNoEvents() {
		CalendarItemRetriever calItemRetriever = new CalendarItemRetriever();
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
		CalendarItemRetriever calItemRetriever = new CalendarItemRetriever();
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

			calHandler.setView(CalendarHandler.CalendarView.WEEK);
			system.assertEquals(CalendarHandler.CalendarView.WEEK, calHandler.View, 'Failed to set calendar view.');

			system.assertEquals(2, calHandler.DayOfWeek, 'Incorrect day of week for active date.');
			system.assertEquals('Monday', calHandler.Weekday, 'Incorrect weekday name for active date.');

		Test.stopTest();
	}

	@isTest static void testMultipleEvents() {

		DateTime startDateTime = DateTime.newInstance(
			Date.newInstance(2014, 02, 17),
			Time.newInstance(13, 30, 0, 0)
			);
		DateTime endDateTime = startDateTime.addHours(1);
		Event e1 = createEvent(startDateTime, endDateTime, 'Event 1');

		startDateTime = DateTime.newInstance(
			Date.newInstance(2014, 03, 17),
			Time.newInstance(13, 30, 0, 0)
			);
		endDateTime = startDateTime.addHours(1);
		Event e2 = createEvent(startDateTime, endDateTime, 'Event 2');

		insert new List<Event>{e1, e2};

		CalendarItemRetriever calItemRetriever = new CalendarItemRetriever();
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

	// simple test for display controller and properties
	@isTest static void testCalendarDisplayController() {

		DateTime startDateTime = DateTime.newInstance(
			Date.newInstance(2014, 02, 17),
			Time.newInstance(13, 30, 0, 0)
			);
		DateTime endDateTime = startDateTime.addHours(1);
		Event e1 = createEvent(startDateTime, endDateTime, 'Event 1');

		startDateTime = DateTime.newInstance(
			Date.newInstance(2014, 03, 17),
			Time.newInstance(13, 30, 0, 0)
			);
		endDateTime = startDateTime.addHours(1);
		Event e2 = createEvent(startDateTime, endDateTime, 'Event 2');

		insert new List<Event>{e1, e2};

		CalendarItemRetriever calItemRetriever = new CalendarItemRetriever();
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

	@isTest static void testCalendarProperties() {
		CalendarParameters cp;
		Test.startTest();
			cp = new CalendarParameters();
		Test.stopTest();
		system.assert(cp.ShowNavigation, 'The default for show navigation should be true.');
		system.assert(cp.ShowHeader, 'The default for show header should be true.');
		system.assert(cp.ShowViewSelect, 'The default for show view select should be true.');
		system.assert(cp.ShowCalendarItemPopup, 'The default for show item popup should be true.');
		system.assertEquals(
			CalendarParameters.CALENDAR_VIEW_MONTH, 
			cp.SelectedView,
			'The default for the calendar view should be \'Month\''
			);
	}
	
	private class CalendarItemRetriever implements ICalendarItemRetriever {

		/**
		*	Get calendar items in a date range
		*
		*	@param	startDate	The start date (inclusive) to retrieve calendar items for
		*	@param	endDate		The end date (inclusive) to retrieve calendar items for
		*
		*	@return	A list of CalendarItem objects
		*/
		public List<CalendarItem> getCalendarItems(Date startDate, Date endDate) {
			List<CalendarItem> calendarItems = new List<CalendarItem>();
			List<Event> events = new List<Event>([
				SELECT Id, Subject, Description, StartDateTime,
					EndDateTime, IsAllDayEvent
				FROM Event
				WHERE StartDateTime >= :startDate
					AND EndDateTime <= :endDate
				LIMIT 1000
				]);
			for (Event e : events) {
				calendarItems.add(
					createCalendarItem(e)
					);
			}

			return calendarItems;
		}

		private CalendarItem createCalendarItem(Event e) {
			CalendarItem calItem = new CalendarItem(e.Id);
			calItem.Name = e.Subject;
			calItem.Description = e.Description;
			calItem.StartDateTime = e.StartDateTime;
			calItem.EndDateTime = e.EndDateTime;
			calItem.IsAllDay = e.IsAllDayEvent;
			calItem.CssClass = 'standard-event';
			return calItem;
		}
	}
}