/**
*   Interface for getting calendar items
*
*   @author Sahil Grover    <sgrover@acumensolutions.com>
*/
public interface CalendarItemRetriever {
    
    /**
    *   Get calendar items in a date range
    *
    *   @param  startDate   The start date (inclusive) to retrieve calendar items for
    *   @param  endDate     The end date (inclusive) to retrieve calendar items for
    *
    *   @return A list of CalendarItem objects
    */
    List<CalendarItem> getCalendarItems(Date startDate, Date endDate);
}