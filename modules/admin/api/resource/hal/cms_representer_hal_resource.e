note
	description: "Summary description for {CMS_ADMIN_ROOT_HAL_RESOURCE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_REPRESENTER_HAL_RESOURCE [G -> RESOURCE[ANY]]

inherit

	REPRESENTER [G]

	SHARED_EJSON

feature -- Representer

	to_resource (a_path: STRING_8; a_resource: G): STRING_8
			-- <Precursor>
		do
			Result := hal_resource (a_path, a_resource)
		end

feature {NONE} -- Implementation

	hal_resource (a_path: STRING_8; a_resource: G): STRING_8

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

			across a_resource.links as c loop
				create l_attribute.make (a_path + c.item.link)
				if c.item.is_uri_template then
					l_attribute.set_name (c.item.rel)
					l_res.add_curie_link (l_attribute)
				else
					create l_link.make_with_attribute (c.item.rel, l_attribute )
					l_attribute.set_href (a_path + c.item.link)
					l_res.add_link (l_link)
				end
			end
			if attached json.value (l_res) as ll_hal then
				 Result := ll_hal.representation
			end
		end
end
