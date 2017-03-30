note
	description: "Summary description for {CMS_ROLE_HAL_RESOURCE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_ROLE_HAL_RESOURCE

inherit

	SHARED_EJSON

feature -- Representer

	to_resource (a_path: STRING_8; a_resource: CMS_USER_ROLE): STRING_8
			-- <Precursor>
		do
			Result := hal_resource (a_path, a_resource)
		end

feature {NONE} -- Implementation

	hal_resource (a_path: STRING_8; a_resource: CMS_USER_ROLE): STRING_8
			-- Return a json hal representation.
		local
			l_hal: JSON_HAL_RESOURCE_CONVERTER
			l_res: HAL_RESOURCE
			l_link: HAL_LINK
			l_attribute: HAL_LINK_ATTRIBUTE
		do
			create Result.make_empty
			create l_hal.make
			json.add_converter (l_hal)
			create l_res.make
			create l_attribute.make (a_path + "/api/rels/{rel}")
			l_attribute.set_name ("ht")
			l_res.add_curie_link (l_attribute)

			create l_attribute.make (a_path + "/api/admin/role/" + a_resource.id.out)
			create l_link.make_with_attribute ("self",l_attribute )
			l_res.add_link (l_link)

			create l_attribute.make (a_path + "/api/admin/role/" + a_resource.id.out)
			create l_link.make_with_attribute ("ht:api-role-update",l_attribute )
			l_res.add_link (l_link)

			create l_attribute.make (a_path + "/api/admin/role/" + a_resource.id.out)
			create l_link.make_with_attribute ("ht:api-role-delete",l_attribute )
			l_res.add_link (l_link)

			create l_attribute.make (a_path + "/api/admin/role/" + a_resource.id.out + "/permissions")
			create l_link.make_with_attribute ("ht:api-role-permissions",l_attribute )
			l_res.add_link (l_link)

			l_res.add_fields ("name", a_resource.name)

			if attached json.value (l_res) as ll_hal then
				 Result := ll_hal.representation
			end
		end

end
