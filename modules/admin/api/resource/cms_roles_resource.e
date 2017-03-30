note
	description: "Summary description for {CMS_ROLES_RESOURCE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_ROLES_RESOURCE

inherit

	RESOURCE[ LIST [CMS_USER_ROLE] ]
		redefine
			initialize
		end

create
	make

feature --{NONE}

	initialize
		do
				-- Rels
			add_link_template ("ht", "/api/rels/{rel}")

				-- Self
			add_link ("self", "/api/admin/roles")

		end
end
