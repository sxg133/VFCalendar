/**
*	Interface for executing a custom calendar event
*
*	@author	Sahil Grover	<sgrover@acumensolutions.com>
*/
public interface ICalendarItemAction {

	/**
	*	Retrieve the label for the custom calendar action
	*
	*	@return	The string label for the calendar action
	*/
	string getActionLabel();

	/**
	*	Should the calendar reload after performing the action
	*
	*	@return	True if the calendar should reload following the custom action, false otherwise
	*/
	boolean getInitOnComplete();
	
	/**
	*	performAction	Calendar action logic
	*	
	*	@return	Return a page to redirect to
	*/
	PageReference performAction();
}