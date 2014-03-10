/**
*	Controller for calendar component demo
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
public with sharing class CalendarExampleController implements ICalendarItemRetriever {

	public CalendarHandler cal {get; private set;}
	public CalendarParameters calParams {get; private set;}

	public CalendarExampleController() {
		calParams = new CalendarParameters();
		cal = new CalendarHandler(this);
	}

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

		// standard events
		List<Event> events = new List<Event>([
			SELECT Id, Subject, Description, StartDateTime,
				EndDateTime, IsAllDayEvent
			FROM Event
			WHERE StartDateTime >= :startDate
				AND EndDateTime <= :endDate
			]);
		for (Event e : events) {
			CalendarItem calItem = createCalendarItem(e);
			calItem.Actions.add( new SwitchCalendarItemTypeAction(calItem) );
			calendarItems.add(calItem);
		}

		// custom events
		List<CustomEvent__c> customEvents = new List<CustomEvent__c>([
			SELECT Id, Name, Description__c, StartDateTime__c,
				EndDateTime__c
			FROM CustomEvent__c
			WHERE StartDateTime__c >= :startDate
				AND EndDateTime__c <= :endDate
			]);
		for (CustomEvent__c e : customEvents) {
			CalendarItem calItem = createCalendarItem(e);
			calItem.Actions.add( new SwitchCalendarItemTypeAction(calItem) );
			calendarItems.add(calItem);
		}

		return calendarItems;
	}

	private CalendarItem createCalendarItem(CustomEvent__c e) {
		CalendarItem calItem = new CalendarItem(e.Id);
		calItem.Name = e.Name;
		calItem.Description = e.Description__c;
		calItem.StartDateTime = e.StartDateTime__c;
		calItem.EndDateTime = e.EndDateTime__c;
		calItem.CssClass = 'custom-event';
		return calItem;
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

	private class SwitchCalendarItemTypeAction implements ICalendarItemAction {

		private CalendarItem calItem;

		public SwitchCalendarItemTypeAction(CalendarItem calItem) {
			this.calItem = calItem;
		}

		/**
		*	Retrieve the label for the custom calendar action
		*
		*	@return	The string label for the calendar action
		*/
		public string getActionLabel() {
			return 'Switch Type';
		}

		/**
		*	Should the calendar reload after performing the action
		*
		*	@return	True if the calendar should reload following the custom action, false otherwise
		*/
		public boolean getInitOnComplete() {
			return true;
		}
		
		/**
		*	performAction	Calendar action logic
		*	
		*	@return	Return a page to redirect to
		*/
		public PageReference performAction() {
			if (calItem.CssClass == 'standard-event') {
				calItem.CssClass = 'custom-event';
			} else {
				calItem.CssClass = 'standard-event';
			}
			return null;
		}

	}
}