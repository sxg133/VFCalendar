/**
*	Parameters for a Calendar display
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
public with sharing class CalendarParameters {

	public static final string CALENDAR_VIEW_MONTH = 'month';
	public static final string CALENDAR_VIEW_WEEK = 'week';
	public static final string CALENDAR_VIEW_DAY = 'day';

	public boolean ShowNavigation {get;set;}			// Show the calendar navigation buttons
	public boolean ShowHeader {get;set;}				// Show the calendar header -- month / year
	public boolean ShowViewSelect {get;set;}			// Show picklist for selecting calendar view
	public string SelectedView {get;set;}				// The selected calendar view
	public boolean ShowCalendarItemPopup {get; set;}	// Show the calendar item popup when a user clicks an event

	public CalendarParameters() {
		ShowNavigation = true;
		ShowHeader = true;
		ShowViewSelect = true;
		SelectedView = CALENDAR_VIEW_MONTH;
		ShowCalendarItemPopup = true;
	}
}