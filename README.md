VFCalendar
==========

Author: Sahil Grover

Date:   2014-03-05

A calendar component for VisualForce pages

![Calendar Month View](https://raw.github.com/sxg133/VFCalendar/master/calendar_month_view.png)

![Calendar Week View](https://raw.github.com/sxg133/VFCalendar/master/calendar_week_view.png)

Documentation
=============

Display standard or custom events and generic items on a VisualForce calendar.  Put the component tag on your VisualForce page.

    <apex:form >
        <c:CalendarDisplay params="{!calParams}" cal="{!cal}" />
	</apex:form>
    
#### Attributes

*  __params__

    An instance of the CalendarParameters class
    
*  __cal__

    An instance of the CalendarHandler class
    
#### Calendar Parameters

*   __ShowNavigation__

    Show the calendar's navigation buttons (default = true)

*   __ShowHeader__

    Show the calendar header (month / year display) (default = true)

*   __ShowCalendarItemPopup__

    Show the popup window when a calendar item is clicked (default = true)
    
#### Basic Implementation

An example controller for the VisualForce page that contains the Calendar Display component:

    public with sharing MyPageController implements ICalendarItemRetriever {

        public CalendarHandler cal {get; private set;}
    	public CalendarParameters calParams {get; private set;}
    
    	public CalendarExampleController() {
    		calParams = new CalendarParameters();
    		cal = new CalendarHandler(this);
    	}
        
        public List<CalendarItem> getCalendarItems(Date startDate, Date endDate) {
            // return list of calendar items
        }
    
    }
    
The *CalendarHandler* constructor accepts an instance of the *ICalendarItemRetriever* interface.  The interface's only method is *getCalendarItems*.  This method accepts a date range, and returns a list of *CalendarItem* objects.  Below is an example of creating a list of calendar items from standard SalesForce events.

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
			CalendarItem calItem = createCalendarItem(e.Id);
        	calItem.Description = e.Description;
    		calItem.StartDateTime = e.StartDateTime;
    		calItem.EndDateTime = e.EndDateTime;
    		calItem.IsAllDay = e.IsAllDayEvent;
			calendarItems.add(calItem);
		}

		return calendarItems;
	}
    
Custom events can also be placed on the calendar, but each calendar item returned must have a unique identifier.  This identifier does not need to be a SalesForce ID, but if the calendar items represent SObjects, SalesForce IDs are recommended.

#### Calendar Actions

Custom events can be attached to calendar items.  Each custom event is represented as an implementation of the *ICalendarItemAction* interface.

When creating a custom action, you may set or add to the *Actions* property of the calendar item.  The sample code below creates a custom action that switches the CSS class of the calendar item.


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
			CalendarItem calItem = createCalendarItem(e.Id);
        	calItem.Description = e.Description;
    		calItem.StartDateTime = e.StartDateTime;
    		calItem.EndDateTime = e.EndDateTime;
    		calItem.IsAllDay = e.IsAllDayEvent;
			calItem.Actions.add( new SwitchCalendarItemTypeAction(calItem) );
			calendarItems.add(calItem);
		}
        
    	return calendarItems;
    }
    
    private class SwitchCalendarItemTypeAction implements ICalendarItemAction {

		private CalendarItem calItem;

		public SwitchCalendarItemTypeAction(CalendarItem calItem) {
			this.calItem = calItem;
		}

		public string getActionLabel() {
			return 'Switch Type';
		}

		public boolean getInitOnComplete() {
			return true;
		}

		public PageReference performAction() {
			if (calItem.CssClass == 'standard-event') {
				calItem.CssClass = 'custom-event';
			} else {
				calItem.CssClass = 'standard-event';
			}
			return null;
		}

	}
    
The action class must implement the following methods:

*   __getActionLabel__

    The action name displayed to the user

*   __getInitOnComplete__

    Returns true if the calendar should be rerendered following the action

*   __performAction__

    Executes the action logic
