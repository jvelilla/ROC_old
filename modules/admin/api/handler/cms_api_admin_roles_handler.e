note
	description: "Summary description for {CMS_API_ADMIN_ROLES_HANLDER}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_API_ADMIN_ROLES_HANDLER

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
			do_post
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

feature -- HTTP Methods

	do_get (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			user_api: CMS_USER_API
			l_hal: CMS_ROLES_HAL_RESOURCE
		do
				-- TODO: Add CONNEG. Not critical for now.
			user_api := api.user_api
			if attached current_user (req) as l_user and then user_api.user_has_permission (l_user, "manage api") then
				if attached user_api.roles  as l_roles then
					create l_hal
					(create {CMS_HAL_RESPONSE}).compute_response_ok (req, res, l_hal.to_resource (req.absolute_script_url (""), l_roles))
				end
			else
				(create {CMS_HAL_RESPONSE}).compute_response_forbidden (req, res, forbidden)
			end
		end


	do_post (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			user_api: CMS_USER_API
			l_data: STRING
			l_json_parser: JSON_PARSER
			l_user_role: CMS_USER_ROLE
		do
				-- TODO: Add CONNEG. Not critical for now.
			user_api := api.user_api
			if attached current_user (req) as l_user and then user_api.user_has_permission (l_user, "manage api") then
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
									create l_user_role.make (l_role_name.item)
									user_api.save_user_role (l_user_role)
									(create {CMS_HAL_RESPONSE}).compute_response_created (req, res, req.absolute_script_url ("/api/admin/role/"+l_user_role.id.out ))
								else
									(create {CMS_HAL_RESPONSE}).compute_response_bad_request (req, res, role_name_taken)
								end
							else
								(create {CMS_HAL_RESPONSE}).compute_response_bad_request (req, res, role_name_invalid)
							end
						else
							(create {CMS_HAL_RESPONSE}).compute_response_bad_request (req, res, role_invalid_input)
						end
					end
				else
					(create {CMS_HAL_RESPONSE}).compute_response_bad_request (req, res, role_invalid_input)
				end
			else
				(create {CMS_HAL_RESPONSE}).compute_response_forbidden (req, res, forbidden)
			end
		end



end
