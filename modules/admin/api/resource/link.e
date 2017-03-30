note
	description: "Represent a resource URI"
	date: "$Date$"
	revision: "$Revision$"

class
	LINK

create
	make

feature {NONE} -- Initialization

	make (a_rel: STRING_8; a_link: STRING_8)
			-- Create a resoource uri with rel `a_rel'  and link `a_link'.
		do
			rel := a_rel
			link := a_link
		ensure
			rel_set: rel = a_rel
			link_set: link = a_link
			no_uri_template: not is_uri_template
		end

feature -- Access

	rel: STRING_8

	link: STRING_8

	is_uri_template: BOOLEAN

feature -- Change Element

	mark_uri_template
		do
				-- Todo we should add a validator to check if the uri is really
				-- a valid uri template.
			is_uri_template := True
		end

end
