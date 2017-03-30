note
	description: "Summary description for {CMS_API_SHARED_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_API_HAL_RESPONSE


feature -- ROLE messages

	role_name_taken : STRING = "[
					{
						"error": {
							"role name": "is already taken"
						}
					}
				]"

	role_name_invalid : STRING = "[
					{
						"error": {
							"role name": "not a valid name"
						}
					}
				]"


	role_invalid_input : STRING = "[
					{
						"error": {
							"input": "not a valid data check the rels for api/rels/api-admin-roles"
						}
					}
				]"


	role_not_found : STRING = "[
					{
						"error": {
							"role": "not found"
						}
					}
				]"


	role_deleted : STRING = "[
					{
						"deleted": {
							"role": "$role"
						}
					}
				]"


feature -- Generic messages

	forbidden : STRING = "[
					{
						"error": "forbidden"
					}
				]"
end
