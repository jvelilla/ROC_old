note
	description: "Summary description for {CMS_HAL_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_HAL_RESPONSE

feature -- Response

	compute_response_ok (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end



	compute_response_forbidden (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.forbidden)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end


	compute_response_not_found (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.not_found)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end



	compute_response_created (req: WSF_REQUEST; res: WSF_RESPONSE; a_location: STRING)
		local
			h: HTTP_HEADER
			hdate: HTTP_DATE
		do
			create h.make
			h.put_location (a_location)
			h.put_content_type_application_json
			h.put_content_length (a_location.count)
			h.put_cache_control ("max-age=0, private, must-revalidate")
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.created)
			res.put_header_text (h.string)
			res.put_string ( a_location)
			res.flush
		end


	compute_response_bad_request (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.bad_request)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end



end
