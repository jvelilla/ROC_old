note
	description: "Summary description for {REPRESENTER}."
	date: "$Date$"
	revision: "$Revision$"

deferred class

	REPRESENTER[T -> RESOURCE[ANY]]

feature

	to_resource (a_path: STRING_8; a_resource: T): STRING_8
			-- transform the generic resource `a_resource' to a
			-- specific media type, using a base location `a_path'.
		deferred
		end
end
