note
	description: "[
			handler for CMS api rest admin in the CMS interface.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_API_ADMIN_HANDLER

inherit
	CMS_HANDLER

	WSF_URI_HANDLER
		rename
			execute as uri_execute,
			new_mapping as new_uri_mapping
		end

	WSF_URI_TEMPLATE_HANDLER
		rename
			execute as uri_template_execute,
			new_mapping as new_uri_template_mapping
		select
			new_uri_template_mapping
		end

	WSF_RESOURCE_HANDLER_HELPER
		redefine
			do_get
		end

	REFACTORING_HELPER

create
	make

feature -- execute

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute_methods (req, res)
		end

	uri_execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute (req, res)
		end

	uri_template_execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute request handler
		do
			execute (req, res)
		end

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_hal: CMS_REPRESENTER_HAL_RESOURCE [CMS_ADMIN_ROOT_RESOURCE]
		do
				-- TODO: Add CONNEG. Not critical for now.

			if attached current_user (req) as l_user and then api.user_api.user_has_permission (l_user, "manage api") then
				create l_hal
				(create {CMS_HAL_RESPONSE}).compute_response_ok (req, res, l_hal.to_resource (req.absolute_script_url (""), create {CMS_ADMIN_ROOT_RESOURCE}.make (create {CMS_ADMIN})))
			else
				create l_hal
				(create {CMS_HAL_RESPONSE}).compute_response_forbidden (req, res, l_hal.to_resource (req.absolute_script_url (""), create {CMS_ADMIN_ROOT_RESOURCE}.make (create {CMS_ADMIN})))
			end
		end
end
