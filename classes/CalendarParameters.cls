/**
*	Parameters for a Calendar display
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
public with sharing class CalendarParameters {

	public enum CalendarView {
		MONTH,
		WEEK
	}

	public boolean ShowNavigation {get;set;}			// Show the calendar navigation buttons
	public boolean ShowHeader {get;set;}				// Show the calendar header -- month / year
	public boolean ShowViewSelect {get;set;}			// Show picklist for selecting calendar view
	public CalendarView SelectedView {get; set;}		// The selected calendar view
	public boolean ShowCalendarItemPopup {get; set;}	// Show the calendar item popup when a user clicks an event

	public String SelectedViewName {
		get {
			return SelectedView.name();
		}
		set {
			if (value == 'MONTH') {
				this.SelectedView = CalendarView.MONTH;
			} else if (value == 'WEEK') {
				this.SelectedView = CalendarView.WEEK;
			} else {
				throw new CalendarException('Unrecognized view name: ' + value);
			}
		}
	}

	public CalendarParameters() {
		ShowNavigation = true;
		ShowHeader = true;
		ShowViewSelect = true;
		SelectedView = CalendarView.MONTH;
		ShowCalendarItemPopup = true;
	}
}