note
	description: "Summary description for {CMS_API_ADMIN_ROLE_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_API_ADMIN_ROLE_HANDLER

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
			do_get,
			do_put,
			do_delete
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
			l_hal: CMS_ROLE_HAL_RESOURCE
		do
				-- TODO: Add CONNEG. Not critical for now.
			user_api := api.user_api
			if attached current_user (req) as l_user and then user_api.user_has_permission (l_user, "manage api") then
				if attached user_api.user_role_by_id (role_id_path_parameter (req).to_integer_32) as l_user_role then
					create l_hal
					(create {CMS_HAL_RESPONSE}).compute_response_ok (req, res, l_hal.to_resource (req.absolute_script_url (""), l_user_role))
				else
					(create {CMS_HAL_RESPONSE}).compute_response_not_found (req, res, role_not_found )
				end
			else
				(create {CMS_HAL_RESPONSE}).compute_response_forbidden (req, res, forbidden)
			end
		end


	do_put (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			user_api: CMS_USER_API
			l_data: STRING
			l_json_parser: JSON_PARSER
		do
				-- TODO: Add CONNEG. Not critical for now.
			user_api := api.user_api
			if attached current_user (req) as l_user and then user_api.user_has_permission (l_user, "manage api") then
				if attached user_api.user_role_by_id (role_id_path_parameter (req).to_integer_32) as l_user_role then
					l_data := retrieve_data (req)
					create l_json_parser.make_with_string (l_data)
					l_json_parser.parse_content
					if l_json_parser.is_parsed then
						if attached {JSON_OBJECT} l_json_parser.parsed_json_object as j_role then
							if
								attached {JSON_STRING} j_role.item (create {JSON_STRING}.make_from_string ("name")) as l_role_name
							then
								if not l_role_name.item.is_empty then
									if  user_api.user_role_by_name (l_role_name.item) = Void then
										l_user_role.set_name (l_role_name.item)
										user_api.save_user_role (l_user_role)
										(create {CMS_HAL_RESPONSE}).compute_response_ok (req, res, req.absolute_script_url ("/api/admin/role/"+l_user_role.id.out ))
									else
										(create {CMS_HAL_RESPONSE}).compute_response_bad_request (req, res, role_name_taken)
									end
								else
									(create {CMS_HAL_RESPONSE}).compute_response_bad_request (req, res, role_invalid_input)
								end
							else
								(create {CMS_HAL_RESPONSE}).compute_response_bad_request (req, res, role_invalid_input)
							end
						end
					else
						(create {CMS_HAL_RESPONSE}).compute_response_bad_request (req, res, role_invalid_input)
					end
				else
					(create {CMS_HAL_RESPONSE}).compute_response_not_found (req, res, role_not_found )
				end
			else
				(create {CMS_HAL_RESPONSE}).compute_response_forbidden (req, res, forbidden)
			end
		end


	do_delete (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			user_api: CMS_USER_API
			l_message: STRING
		do
				-- TODO: Add CONNEG. Not critical for now.
			user_api := api.user_api
			if attached current_user (req) as l_user and then user_api.user_has_permission (l_user, "manage api") then
				if attached user_api.user_role_by_id (role_id_path_parameter (req).to_integer_32) as l_user_role then
					user_api.delete_role (l_user_role)
					create l_message.make_from_string (role_deleted)
					l_message.replace_substring_all ("$role", l_user_role.name)
					(create {CMS_HAL_RESPONSE}).compute_response_ok (req, res, l_message )
				else
					(create {CMS_HAL_RESPONSE}).compute_response_not_found (req, res, role_not_found )
				end
			else
				(create {CMS_HAL_RESPONSE}).compute_response_forbidden (req, res, forbidden )
			end
		end
end
