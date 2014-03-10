/**
*	Controller for Calendar Display component
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
public with sharing class CalendarDisplayController {
	public CalendarHandler CalHandler {get; set;}
	public string SelectedCalendarItemId {get; set;}
	public CalendarItem SelectedCalendarItem {
		get {
			try {
				return CalHandler.getCalendarItem(SelectedCalendarItemId);
			} catch (CalendarException ex) {
				return null;
			}
		}
	}
	public Date SelectedDate {
		get {
			return CalHandler.ActiveDate;
		} 
		set {
			CalHandler.setDate(value);
		}
	}

	public void goToToday() {
		CalHandler.setDate(Date.today());
	}

	// dummy method for setting selected calendar item
	public void setSelectedCalendarItem() {}
}