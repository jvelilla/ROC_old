note
	description: "Resource object, a wrapper of a domain with links"
	date: "$Date$"
	revision: "$Revision$"

class
	RESOURCE [G]

create
	make

feature {NONE} -- Initialization

	make (a_domain: G)
			-- Create a new resource
		do
			domain := a_domain
			create {ARRAYED_LIST [LINK] }links.make (0)
			initialize
		ensure
			domain_set: domain = a_domain
		end

	initialize
			-- To be redefined.
		do
		end

feature -- Access

	links: LIST [LINK]
		-- List of links (rel, link, and tempalte)

feature -- Domain

	domain: G
		-- Object wrapped in a Resource.

feature {NONE} -- Implementation

	add_link (a_rel : READABLE_STRING_8; a_link: READABLE_STRING_8)
			-- add a rel `a_rel' with link `a_link' to the table of links.
		local
			l_link: LINK
		do
			create l_link.make (a_rel, a_link)
			links.force (l_link)
		end

	add_link_template (a_rel : READABLE_STRING_8; a_link: READABLE_STRING_8)
			-- add a rel `a_rel' with link `a_link' to the table of links.
		local
			l_link: LINK
		do
			create l_link.make (a_rel, a_link)
			l_link.mark_uri_template
			links.force (l_link)
		end

end
