note
	description: "ROC CMS HAL API"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=ROC CMS REST API", "src=https://docs.google.com/document/d/1DYpX46Urp1XC1g5KTevl_qroCumNEFCgYSfTw5to2_4/edit", "protocol=uri"
class
	ROC_API

inherit

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make (a_base_uri: READABLE_STRING_8; a_username: READABLE_STRING_32; a_password: READABLE_STRING_32)
			-- Create an object roc with a base uri `a_base_uri' user `a_username' and  password `a_password'.
		do
			create admin_api.make (a_base_uri, a_username, a_password)
		end

	admin_api: ROC_ADMIN_API
			-- Admin API.

feature -- Admin: Roles

	roles: STRING
			-- Show Roles
		do
				-- TODO: check if we should build
				-- a Module to represent roles
				-- so admin_api.roles shoud return a LIST[CMS_ROLES]
			fixme ("Remove redirection")
				-- So no need for this feature just
				-- admin api.	
			Result := admin_api.roles
		end

	role (a_id: INTEGER_64): STRING
			-- Show a role by id `a_id', if exist.
		require
			valid_id: a_id > 0
		do
			Result := admin_api.role (a_id)
		end

	new_role (a_role: READABLE_STRING_32): STRING
			-- Create a new role with name `a_role'.
		require
			valid_role: not a_role.is_empty
		do
			Result := admin_api.new_role (a_role)
		end

	update_role (a_rid: INTEGER_64; a_role: READABLE_STRING_32): STRING
			-- Update role `a_rid' with a new name `a_role'.
		require
			valid_id: a_rid > 0
			valid_role: not a_role.is_empty
		do
			Result := admin_api.update_role (a_rid, a_role)
		end

	delete_role (a_rid: INTEGER_64): STRING
		require
			valid_id: a_rid > 0
		do
			Result := admin_api.delete_role (a_rid)
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
