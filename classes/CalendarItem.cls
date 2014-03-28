/**
*	An item to display on the calendar viewer component
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
public with sharing virtual class CalendarItem implements Comparable {

	public string ItemId {get; private set;}
	public string Name {get; set;}
	public string Description {get; set;}

	public DateTime StartDateTime {
		get {
			return itemStartDateTime;
		}
		set {
			itemStartDateTime = value;
			itemStartDate = value.date();
		}
	}

	public string FormattedStartDateTime {
		get {
			return StartDateTime.format('MMMM d, h:mm a');
		}
	}

	public string FormattedStartDate {
		get {
			return StartDateTime.format('MMMM d');
		}
	}

	public string FormattedStartTime {
		get {
			return StartDateTime.format('h:mm a');
		}
	}

	public DateTime EndDateTime {
		get {
			return itemEndDateTime;
		}
		set {
			itemEndDateTime = value;
			itemEndDate = value.date();
		}
	}

	public string FormattedEndDateTime {
		get {
			return EndDateTime.format('MMMM d, h:mm a');
		}
	}

	public string FormattedEndDate {
		get {
			return EndDateTime.format('MMMM d');
		}
	}

	public string FormattedEndTime {
		get {
			return EndDateTime.format('h:mm a');
		}
	}

	public Date StartDate {
		get {
			return itemStartDate;
		}
		set {
			itemStartDate = value;
			itemStartDateTime = DateTime.newInstance(
				value,
				Time.newInstance(0, 0, 0, 0)
				);
		}
	}

	public Date EndDate {
		get {
			return itemEndDate;
		}
		set {
			itemEndDate = value;
			itemEndDateTime = DateTime.newInstance(
				value,
				Time.newInstance(23, 60, 59, 999)
				);
		}
	}

	public boolean IsAllDay {get; set;}

	public double DurationInMinutes {
		get {
			if (this.IsAllDay) {
				return 1440; // 24 * 60
			} else if (StartDateTime != null && EndDateTime != null) {
				return Math.Ceil(EndDateTime.getTime() - StartDateTime.getTime()) / 1000 / 60;
			}
			throw new CalendarException('The duration cannot be calculated without start and end times.');
		}
	}

	// The duration of the item as a percent of one 30 minute block
	public double DurationPercent {
		get {
			if (this.IsAllDay) {
				return 4800; // (24 * 60) / 30 * 100
			}
			return Math.Ceil( (DurationInMinutes / 30) * 100 );
		}
	}

	public List<CalendarItemAction> Actions {get; set;}
	public string CssClass {get; set;}
	public string DetailUrl {get; set;}

	private Date itemStartDate;
	private DateTime itemStartDateTime;
	private Date itemEndDate;
	private DateTime itemEndDateTime;

	public CalendarItem(string itemId) {
		this(itemId, new List<CalendarItemAction>());
	}

	public CalendarItem(string itemId, List<CalendarItemAction> actions) {
		this.ItemId = itemId;
		this.Actions = actions;
		this.DetailUrl = '/' + this.ItemId;
		this.IsAllDay = false;
	}

	/**
	*	Compare two calendar items
	*
	*	@param	calItemObject	A calendar item to compare to
	*
	*	@return	Returns 1 if this is greater, -1 if this is less, 0 if they are equal
	*/
	public integer compareTo(Object calItemObject) {
		CalendarItem calItem = (CalendarItem)calItemObject;
		if (this.StartDateTime > calItem.StartDateTime) {
			return 1;
		} else if (this.StartDateTime < calItem.StartDateTime) {
			return -1;
		}
		return 0;
	}
}