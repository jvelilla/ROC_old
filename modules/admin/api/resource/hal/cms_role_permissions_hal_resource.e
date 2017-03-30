note
	description: "Summary description for {CMS_ROLE_PERMISSIONS_RESOURCE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_ROLE_PERMISSIONS_HAL_RESOURCE

inherit

	CMS_SHARED_SORTING_UTILITIES

	SHARED_EJSON

feature -- Representer

	to_resource (a_path: STRING_8; a_role:CMS_USER_ROLE; a_permissions_by_module: HASH_TABLE [LIST [READABLE_STRING_8], STRING_8]): STRING_8
		do
			Result := hal_resource (a_path, a_role, a_permissions_by_module)
		end

feature {NONE} -- Implementation

	hal_resource (a_path: STRING_8;  a_role:CMS_USER_ROLE; a_permissions_by_module: HASH_TABLE [LIST [READABLE_STRING_8], STRING_8]): STRING_8
			-- Return a json hal representation.
		local
			l_hal: JSON_HAL_RESOURCE_CONVERTER
			l_res: HAL_RESOURCE
			l_link: HAL_LINK
			l_attribute: HAL_LINK_ATTRIBUTE
			l_role_permissions: detachable LIST [READABLE_STRING_8]
			l_module_names: ARRAYED_LIST [READABLE_STRING_8]
			l_mod_name: READABLE_STRING_8

		do
			create Result.make_empty
			create l_hal.make
			json.add_converter (l_hal)
			create l_res.make
			create l_attribute.make (a_path + "/api/rels/{rel}")
			l_attribute.set_name ("ht")
			l_res.add_curie_link (l_attribute)

			create l_attribute.make (a_path + "/api/admin/roles/" + a_role.id.out + "/permissions")
			create l_link.make_with_attribute ("self",l_attribute )
			l_res.add_link (l_link)

			l_role_permissions := a_role.permissions
			l_role_permissions.compare_objects
			create l_module_names.make (a_permissions_by_module.count)
			across
				a_permissions_by_module as mod_ic
			loop
				l_module_names.force (mod_ic.key)
			end
			string_sorter.sort (l_module_names)


			across
				l_module_names as mod_ic
			loop
				l_mod_name := mod_ic.item
				if
					attached a_permissions_by_module.item (l_mod_name) as l_permissions and then
					not l_permissions.is_empty
				then
					if l_mod_name.is_whitespace then
						l_mod_name := "... "
					end
					string_sorter.sort (l_permissions)
					l_res.add_embedded_resources_with_key ("ht:module-"+ l_mod_name, hal_embeded_resource (a_path, a_role.id.out, l_permissions, l_role_permissions))
				end
			end

			if attached json.value (l_res) as ll_hal then
				 Result := ll_hal.representation
			end

		end


	hal_embeded_resource (a_path: STRING_8; a_role_id:STRING_8; a_permissions: LIST[READABLE_STRING_8]; a_role_permissions: LIST[READABLE_STRING_8]): LIST[HAL_RESOURCE]
		local
			l_res: HAL_RESOURCE
			l_link: HAL_LINK
			l_attribute: HAL_LINK_ATTRIBUTE
		do
			create {ARRAYED_LIST [HAL_RESOURCE]} Result.make (0)

			across a_permissions as ic loop
					create l_res.make
					create l_attribute.make (a_path + "/api/admin/roles/" + a_role_id + "/permissions")
					create l_link.make_with_attribute ("self",l_attribute )
					l_res.add_link (l_link)
					l_res.add_fields (ic.item, (across a_role_permissions as rp_ic some rp_ic.item.is_case_insensitive_equal (ic.item) end).out)
					Result.force (l_res)
			end

		end
end
