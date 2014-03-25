/**
*	Holds information for the date range being viewed on a calendar
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
public with sharing class CalendarHandler {

	private static final integer NUMBER_OF_DAYS_IN_WEEK = 7;

	private static final string[] weekdays = new string[]{
		'Sunday',
		'Monday',
		'Tuesday',
		'Wednesday',
		'Thursday',
		'Friday',
		'Saturday'
	};

	public string[] WeekdayNames {
		get {
			return weekdays;
		}
	}

	public Date ActiveDate { get; private set; }
	public Date StartOfWeek {
		get {
			return this.ActiveDate.toStartOfWeek();
		}
	}
	public Date EndOfWeek {
		get {
			return this.StartOfWeek.addDays(6);
		}
	}
	public Date StartOfMonth {
		get {
			return this.ActiveDate.toStartOfMonth();
		}
	}
	public Date EndOfMonth {
		get {
			return this.StartOfMonth.addMonths(1).addDays(-1);
		}
	}
	public integer DayOfWeek {
		get {
			return -1 * (this.ActiveDate.daysBetween(this.StartOfWeek) - 1);
		}
	}
	public string Weekday {
		get {
			return weekdays[this.DayOfWeek - 1];
		}
	}
	public integer WeekOfMonth {
		get {
			for (integer i=0; i<Weeks.size(); i++) {
				if (Weeks[i].isInWeek(ActiveDate)) {
					return i;
				}
			}
			throw new CalendarException('The active date does not fall within any week.');
		}
	}
	public CalendarWeek ActiveWeek {
		get {
			return Weeks[WeekOfMonth];
		}
	}
	public List<CalendarWeek> Weeks {get; private set;}
	public List<CalendarItem> Items {get; private set;}

	private ICalendarItemRetriever calendarItemRetriever;

	public CalendarHandler(ICalendarItemRetriever calendarItemRetriever) {
		this(calendarItemRetriever, Date.today());
	}

	public CalendarHandler(ICalendarItemRetriever calendarItemRetriever, Date activeDate) {
		this.calendarItemRetriever = calendarItemRetriever;
		setDate(activeDate);
	}

	/**
	*	Add years to the active calendar date
	*
	*	@param	numberOfYears	The number of years to add to the active date
	*/
	public void addYears(integer numberOfYears) {
		setDate(this.ActiveDate.addYears(numberOfYears));
	}

	/**
	*	Add months to the active calendar date
	*
	*	@param	numberOfMonths	The number of months to add to the active date
	*/
	public void addMonths(integer numberOfMonths) {
		setDate(this.ActiveDate.addMonths(numberOfMonths));
	}

	/**
	*	Add weeks to the active calendar date
	*
	*	@param	numberOfWeeks	The number of weeks to add to the active date
	*/
	public void addWeeks(integer numberOfWeeks) {
		setDate(this.ActiveDate.addDays(numberOfWeeks * NUMBER_OF_DAYS_IN_WEEK));
	}

	/**
	*	Add days to the active calendar date
	*
	*	@param	numberOfDays	The number of days to add to the active date
	*/
	public void addDays(integer numberOfDays) {
		setDate(this.ActiveDate.addDays(numberOfDays));
	}

	/**
	*	Set the active calendar date
	*
	*	@param	activeDate	The new active calendar date
	*/
	public void setDate(Date activeDate) {
		boolean isNewMonth = true;
		if (this.ActiveDate != null) {
			isNewMonth = activeDate.month() != this.ActiveDate.month()
				|| activeDate.year() != this.ActiveDate.year();
		}
		this.ActiveDate = activeDate;
		if (isNewMonth) {
			updateCalendarWeeks();
			setCalendarWeekItems();
		}
	}

	private void updateCalendarWeeks() {
		Weeks = new List<CalendarWeek>();
		Date d = this.ActiveDate.toStartOfMonth().toStartOfWeek();
		Date endMonth = this.ActiveDate.addMonths(1).toStartOfMonth();
		while (d < endMonth) {
			Weeks.add( new CalendarWeek(d) );
			d = d.addDays(NUMBER_OF_DAYS_IN_WEEK);
		}
	}

	private void setCalendarWeekItems() {
		Date startDate = this.Weeks[0].Days[0].CalendarDate;
		Date endDate = 
			this.Weeks[this.Weeks.size()-1]
			.Days[NUMBER_OF_DAYS_IN_WEEK-1]
			.CalendarDate;
		this.Items = calendarItemRetriever.getCalendarItems(startDate, endDate);
		for (CalendarWeek week : Weeks) {
			List<CalendarItem> weekItems = new List<CalendarItem>();
			for (CalendarItem monthItem : Items) {
				if (monthItem.StartDate >= week.StartDate && monthItem.EndDate <= week.EndDate) {
					weekItems.add(monthItem);
				}
			}
			week.Items = weekItems;
		}
	}

	/**
	*	Go to the next day
	*/
	public void goToNextDay() {
		this.addDays(1);
	}

	/**
	*	Go to the previous day
	*/
	public void goToPreviousDay() {
		this.addDays(-1);
	}

	/**
	*	Go to the next week
	*/
	public void goToNextWeek() {
		this.addWeeks(1);
	}

	/**
	*	Go to the previous week
	*/
	public void goToPreviousWeek() {
		this.addWeeks(-1);
	}

	/**
	*	Go to the next month
	*/
	public void goToNextMonth() {
		this.addMonths(1);
	}

	/**
	*	Go to the previous month
	*/
	public void goToPreviousMonth() {
		this.addMonths(-1);
	}

	/**
	*	Go to the next year
	*/
	public void goToNextYear() {
		this.addYears(1);
	}

	/**
	*	Go to the previous year
	*/
	public void goToPreviousYear() {
		this.addYears(-1);
	}

	/**
	*	Get a calendar item by ID
	*
	*	@param	itemId	The ID of the calendar item to retrieve
	*
	*	@return	Returns the calendar item matching the ID
	*/
	public CalendarItem getCalendarItem(string itemId) {
		for (CalendarItem item : Items) {
			if (item.ItemId == itemId) {
				return item;
			}
		}
		throw new CalendarException('Could not find Calendar Item with ID: ' + itemId);
	}

	private class CalendarWeek {
		public CalendarDay[] Days {get; private set;}
		public Date StartDate {get; private set;}
		public Date EndDate {
			get {
				return StartDate.addDays(6);
			}
		}
		public List<CalendarItem> Items {
			get; 
			set {
				Items = value;
				setCalendarDayItems();
			}
		}

		public CalendarWeek(Date startDate) {
			this.StartDate = startDate;
			updateCalendarDays();
			this.Items = new List<CalendarItem>();
		}

		/**
		*	Determine if a date falls in the week
		*
		*	@param	d	The date to check
		*
		*	@return Returns true if the date falls in the week
		*/
		public boolean isInWeek(Date d) {
			return StartDate <= d && d <= EndDate;
		}

		private void updateCalendarDays() {
			Days = new CalendarDay[NUMBER_OF_DAYS_IN_WEEK];
			Date d=this.StartDate;
			for (integer i=0; i<Days.size(); i++) {
				Days[i] = new CalendarDay(d);
				d = d.addDays(1);
			}
		}

		private void setCalendarDayItems() {
			for (CalendarDay day : Days) {
				for (CalendarItem item : Items) {
					if (item.StartDate == day.CalendarDate) {
						day.Items.add(item);
					}
				}
			}
		}
	}

	private class CalendarDay {
		public Date CalendarDate {get; private set;}
		public List<CalendarItem> Items {get; set;}

		public CalendarDay(Date day) {
			this.CalendarDate = day;
			this.Items = new List<CalendarItem>();
		}
	}
}