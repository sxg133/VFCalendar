/**
*	Helper class for calendar tests
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
@isTest
public class CalendarTestHelper {
	
	public static Event createEvent(DateTime startDateTime, DateTime endDateTime, string subject) {
		Event e = new Event();
		e.StartDateTime = startDateTime;
		e.EndDateTime = endDateTime;
		e.Subject = subject;
		return e;
	}
	
	public class StandardEventRetriever implements CalendarItemRetriever {

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