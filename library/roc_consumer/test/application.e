note
	description : "test_redwood application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_roc: ROC_API
		do
			create l_roc.make ("http://localhost:9090/api", "admin", "istrator#")
			print ("Roles%N")
			print (l_roc.roles)
			print ("%NRole%N")
			print (l_roc.role (1))
			print ("%NNew Role%N")
			print (l_roc.new_role ("testing_role"))
			print ("%NUpdate Role%N")
			print (l_roc.update_role (10, "updating_testing_role"))
			print ("%NDelete Role%N")
			print (l_roc.delete_role (10))
		end

end
