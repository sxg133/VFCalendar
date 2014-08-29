/**
*   Interface for executing a custom calendar event
*
*   @author Sahil Grover    <sgrover@acumensolutions.com>
*/
public interface CalendarItemAction {

    /**
    *   Retrieve the label for the custom calendar action
    *
    *   @return The String label for the calendar action
    */
    String getActionLabel();

    /**
    *   Should the calendar reload after performing the action
    *
    *   @return True if the calendar should reload following the custom action, false otherwise
    */
    boolean getInitOnComplete();
    
    /**
    *   performAction   Calendar action logic
    *   
    *   @return Return a page to redirect to
    */
    PageReference performAction();
}