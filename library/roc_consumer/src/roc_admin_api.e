note
	description: "REST API client providing administrations support for Roles and Users"
	date: "$Date$"
	revision: "$Revision$"

class
	ROC_ADMIN_API

inherit

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make (a_base_uri: READABLE_STRING_8; a_username: READABLE_STRING_32; a_password: READABLE_STRING_32)
			-- `a_username' and  password `a_password'.
		local
			l_uri: STRING_8
		do
			create l_uri.make_from_string (a_base_uri)
			l_uri.append ("/admin")
			create client_proxy.make (l_uri, a_username, a_password)
		end

	client_proxy: ROC_CLIENT_PROXY

feature -- Access: Roles

	roles: STRING
		do
			if attached {RESPONSE} client_proxy.get ("roles") as l_response then
				debug ("roc_admin_api")
					print ("%NGET")
					print ("%NStatus:" + l_response.status.out + "%N")
				end
				if attached l_response.body as l_body then
					debug ("roc_admin_api")
						print ("%NBody:" + l_body + "%N")
					end
					Result := l_body
				else
					fixme ("Generate a valid JSON")
					Result := "{" + l_response.status.out + "}"
				end
			else
				Result := error_message
			end
		end

	role (a_id: INTEGER_64): STRING
		do
			if attached {RESPONSE} client_proxy.get ("role/" + a_id.out) as l_response then
				debug ("roc_admin_api")
					print ("%NGET")
					print ("%NStatus:" + l_response.status.out + "%N")
				end
				if attached l_response.body as l_body then
					debug ("roc_admin_api")
						print ("%NBody:" + l_body + "%N")
					end
					Result := l_body
				else
					Result := "{" + l_response.status.out + "}"
				end
			else
				Result := error_message
			end
		end

feature -- Change Element: Role

	new_role (a_role: READABLE_STRING_32): STRING
		local
			l_data: STRING_32
		do
			create l_data.make_from_string (new_role_template)
			l_data.replace_substring_all ("$new_role", a_role)
			if attached {RESPONSE} client_proxy.post ("roles", l_data) as l_response then
				debug ("roc_admin_api")
					print ("%NPOST")
					print ("%NStatus:" + l_response.status.out + "%N")
				end
				if attached l_response.body as l_body then
					debug ("roc_admin_api")
						print ("%NBody:" + l_body + "%N")
					end
					Result := l_body
				else
					Result := "{" + l_response.status.out + "}"
				end
			else
				Result := error_message
			end
		end

	update_role (a_rid: INTEGER_64; a_role: READABLE_STRING_32): STRING
		local
			l_data: STRING_32
		do
			create l_data.make_from_string (new_role_template)
			l_data.replace_substring_all ("$new_role", a_role)
			if attached {RESPONSE} client_proxy.put ("role/"+ a_rid.out , l_data) as l_response then
				debug ("roc_admin_api")
					print ("%NPUT")
					print ("%NStatus:" + l_response.status.out + "%N")
				end
				if attached l_response.body as l_body then
					debug ("roc_admin_api")
						print ("%NBody:" + l_body + "%N")
					end
					Result := l_body
				else
					Result := "{" + l_response.status.out + "}"
				end
			else
				Result := error_message
			end
		end

	delete_role (a_rid: INTEGER_64): STRING
		do
			if attached {RESPONSE} client_proxy.delete ("role/"+ a_rid.out) as l_response then
				debug ("roc_admin_api")
					print ("%NDELETE")
					print ("%NStatus:" + l_response.status.out + "%N")
				end
				if attached l_response.body as l_body then
					debug ("roc_admin_api")
						print ("%NBody:" + l_body + "%N")
					end
					Result := l_body
				else
					Result := "{" + l_response.status.out + "}"
				end
			else
				Result := error_message
			end
		end

feature {NONE} -- Implementation

	new_role_template: STRING = "[
		{"name":"$new_role"}
	]"

	error_message: STRING = "[
			"error": {
						"server": "500 Internal server error"
				}
		]"

note
	copyright: "2011-2015 Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
