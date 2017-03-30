note
	description: "Summary description for {CMS_API_ADMIN_ROLE_PERMISSIONS_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_API_ADMIN_ROLE_PERMISSIONS_HANDLER

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

	CMS_API_HAL_RESPONSE

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

	role_id_path_parameter (req: WSF_REQUEST): INTEGER_64
			-- User id passed as path parameter for request `req'.
		local
			s: STRING
		do
			if attached {WSF_STRING} req.path_parameter ("id") as p_nid then
				s := p_nid.value
				if s.is_integer_64 then
					Result := s.to_integer_64
				end
			end
		end

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			user_api: CMS_USER_API
			l_hal: CMS_ROLE_PERMISSIONS_HAL_RESOURCE
		do
				-- TODO: Add CONNEG. Not critical for now.
			user_api := api.user_api
			if attached current_user (req) as l_user and then user_api.user_has_permission (l_user, "manage api") then
				if attached {CMS_USER_ROLE} user_api.user_role_by_id (role_id_path_parameter (req).to_integer_32) as l_user_role and then
				   attached user_api.role_permissions as l_permissions_by_module
				 then
					create l_hal
					(create {CMS_HAL_RESPONSE}).compute_response_ok (req, res, l_hal.to_resource (req.absolute_script_url (""), l_user_role, l_permissions_by_module))
				end
			else
				(create {CMS_HAL_RESPONSE}).compute_response_forbidden (req, res, forbidden )
			end
		end

end


