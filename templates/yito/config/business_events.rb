# Configure the business events processors
#
# For example:
# ------------
#
# BusinessEvents::BusinessEvent.register_processor(:new_booking, 
#	:send_email, Commands::NewBookingBusinessEventCommand, 
#   {:autoexecute => true})
#