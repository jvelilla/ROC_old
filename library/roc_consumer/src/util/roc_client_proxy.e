note
	description: "Summary description for {ROC_CLIENT_PROXY}."
	date: "$Date$"
	revision: "$Revision$"

class
	ROC_CLIENT_PROXY

create
	make

feature {NONE} -- Initialization

	make (a_base_uri: READABLE_STRING_8; a_username: READABLE_STRING_32; a_password: READABLE_STRING_32)
			-- Create an object roc with a base uri `a_base_uri' user `a_username' and  password `a_password'.
		do
			base_uri := a_base_uri
			username := a_username
			password := a_password
		ensure
			base_uri_set: base_uri = a_base_uri
			username_set: username = a_username
			password_set: password = a_password
		end

feature -- Access

	base_uri: READABLE_STRING_8
			-- base uri.

	username: READABLE_STRING_32
			-- user name

	password: READABLE_STRING_32
			-- password

feature -- Authentication

	basic_auth: detachable IMMUTABLE_STRING_8
		local
			h: HTTP_AUTHORIZATION
		do
			create h.make_basic_auth (username, password)
			if attached h.http_authorization as s then
				Result := S
			end
		end

feature -- REST API

	get (a_path: detachable READABLE_STRING_8): detachable RESPONSE
			-- Reading Data
		local
			l_request: REQUEST
		do
			create l_request.make ("GET", new_uri (a_path))
			if attached basic_auth as l_auth then
				l_request.add_header ("Authorization", l_auth)
			end
			Result := l_request.execute
		end

	put (a_path: detachable READABLE_STRING_8; a_value: READABLE_STRING_8): detachable RESPONSE
			-- Writing data
		require
			is_json_value: is_valid_json (a_value)
		local
			l_request: REQUEST
		do
			create l_request.make ("PUT", new_uri (a_path))
			l_request.add_payload (a_value)
			Result := l_request.execute
		end

	post (a_path: detachable READABLE_STRING_8; a_value: READABLE_STRING_8): detachable RESPONSE
			-- Pushing Data
		require
			is_json_value: is_valid_json (a_value)
		local
			l_request: REQUEST
		do
			create l_request.make ("POST", new_uri (a_path))
			l_request.add_header ("Content-Type", "application/json")
			l_request.add_payload (a_value)
			Result := l_request.execute
		end

	patch (a_path: detachable READABLE_STRING_8; a_value: READABLE_STRING_8): detachable RESPONSE
			-- Updating Data
		require
			is_json_value: is_valid_json (a_value)
		local
			l_request: REQUEST
		do
			create l_request.make ("PATCH", new_uri (a_path))
			l_request.add_payload (a_value)
			Result := l_request.execute
		end

	delete (a_path: detachable READABLE_STRING_8): detachable RESPONSE
			-- Removing Data
		local
			l_request: REQUEST
		do
			create l_request.make ("DELETE", new_uri (a_path))
			Result := l_request.execute
		end

feature -- Query

	is_valid_json (a_value: READABLE_STRING_32): BOOLEAN
			-- Is a_value a valid json representation?
		local
			l_parse: JSON_PARSER
		do
			create l_parse.make_with_string (a_value)
			l_parse.parse_content
			Result := attached l_parse.is_parsed
		end

feature {NONE} -- Implementation

	new_uri (a_path: detachable READABLE_STRING_8): STRING_8
			-- new uri (base_uri + a_path)
		local
			l_path: STRING_8
		do
			if attached a_path as ll_path then
				l_path := ll_path
			else
				l_path := ""
			end
			if not l_path.is_empty and then not (l_path.starts_with ("/") or l_path.starts_with ("\")) then
				l_path.prepend ("/")
			end
			Result := base_uri + l_path
		end

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
