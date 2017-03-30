note
	description: "Summary description for {CMS_USER_ROLE_RESOURCE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_USER_ROLE_RESOURCE

inherit

	RESOURCE[CMS_USER_ROLE]
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
			add_link ("self", "/api/admin")

				-- Roles
			add_link ("ht:api-admin-roles", "/api/admin/roles")

				-- Users
			add_link ("ht:api-admin-users", "/api/admin/users")
		end

end
