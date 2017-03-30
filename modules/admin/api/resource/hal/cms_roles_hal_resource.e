note
	description: "Summary description for {CMS_ROLES_HAL_RESOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_ROLES_HAL_RESOURCE

inherit

	SHARED_EJSON

feature -- Representer

	to_resource (a_path: STRING_8; a_resource: LIST[CMS_USER_ROLE]): STRING_8
			-- <Precursor>
		do
			Result := hal_resource (a_path, a_resource)
		end

feature {NONE} -- Implementation

	hal_resource (a_path: STRING_8; a_resource: LIST[CMS_USER_ROLE]): STRING_8
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

			create l_attribute.make (a_path + "/api/admin/roles")
			create l_link.make_with_attribute ("self",l_attribute )
			l_res.add_link (l_link)

			l_res.add_embedded_resources_with_key ("ht:api-roles", build_embeded_resource (a_path, a_resource))


			if attached json.value (l_res) as ll_hal then
				 Result := ll_hal.representation
			end

		end


	build_embeded_resource (a_path: STRING_8; a_resource: LIST[CMS_USER_ROLE]): LIST[HAL_RESOURCE]
		local
			l_res: HAL_RESOURCE
			l_link: HAL_LINK
			l_attribute: HAL_LINK_ATTRIBUTE
		do
			create {ARRAYED_LIST [HAL_RESOURCE]} Result.make (0)

			across a_resource as c loop
				create l_res.make
				create l_attribute.make (a_path + "/api/admin/role/" + c.item.id.out)
				create l_link.make_with_attribute ("self",l_attribute )
				l_res.add_link (l_link)

				create l_attribute.make (a_path + "/api/admin/role/" + c.item.id.out)
				create l_link.make_with_attribute ("ht:api-role-update",l_attribute )
				l_res.add_link (l_link)

				create l_attribute.make (a_path + "/api/admin/role/" + c.item.id.out)
				create l_link.make_with_attribute ("ht:api-role-delete",l_attribute )
				l_res.add_link (l_link)

				create l_attribute.make (a_path + "/api/admin/role/" + c.item.id.out + "/permissions")
				create l_link.make_with_attribute ("ht:api-role-permissions",l_attribute )
				l_res.add_link (l_link)

				l_res.add_fields ("name", c.item.name)
				Result.force (l_res)
			end
		end

end
