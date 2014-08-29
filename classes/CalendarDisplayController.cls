/**
*	Controller for Calendar Display component
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
public with sharing class CalendarDisplayController {
	public CalendarHandler CalHandler {get; set;}
	public CalendarParameters CalParams {get; set;}
	public String SelectedCalendarItemId {get; set;}
	public String ViewSelection {get; set;}
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

	public void goToNextUnit() {
		if (CalParams.SelectedView == CalendarParameters.CalendarView.MONTH) {
			CalHandler.goToNextMonth();
		} else if (CalParams.SelectedView == CalendarParameters.CalendarView.WEEK) {
			CalHandler.goToNextWeek();
		}
	}

	public void goToNextBigUnit() {
		if (CalParams.SelectedView == CalendarParameters.CalendarView.MONTH) {
			CalHandler.goToNextYear();
		} else if (CalParams.SelectedView == CalendarParameters.CalendarView.WEEK) {
			CalHandler.goToNextMonth();
		}
	}

	public void goToPreviousUnit() {
		if (CalParams.SelectedView == CalendarParameters.CalendarView.MONTH) {
			CalHandler.goToPreviousMonth();
		} else if (CalParams.SelectedView == CalendarParameters.CalendarView.WEEK) {
			CalHandler.goToPreviousWeek();
		}
	}

	public void goToPreviousBigUnit() {
		if (CalParams.SelectedView == CalendarParameters.CalendarView.MONTH) {
			CalHandler.goToPreviousYear();
		} else if (CalParams.SelectedView == CalendarParameters.CalendarView.WEEK) {
			CalHandler.goToPreviousMonth();
		}
	}

	public void changeView() {
		CalParams.SelectedViewName = ViewSelection;
	}

	// dummy method for setting selected calendar item
	public void setSelectedCalendarItem() {}
}