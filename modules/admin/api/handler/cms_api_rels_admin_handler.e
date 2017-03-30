note
	description: "Summary description for {CMS_API_RELS_ADMIN_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_API_RELS_ADMIN_HANDLER

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
			do_get
		end

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
		do
				-- TODO analize if it's ok to define Rels definitions
				-- as external HTML files.
			if attached {WSF_STRING} req.path_parameter ("rel") as l_rel then
				if l_rel.value.same_string ("api-admin-roles") then
					compute_response_get (req, res, rel_api_admin_roles, "text/html")
				elseif l_rel.value.same_string ("api-role-permissions") then
					compute_response_get (req, res, rel_api_role_permissions, "text/html")
				elseif l_rel.value.same_string ("api-role-update") then
					compute_response_get (req, res, rel_api_role_update, "text/html")
				elseif l_rel.value.same_string ("api-role-delete") then
					compute_response_get (req, res, rel_api_role_delete, "text/html")
				end
			end
		end

feature -- Rels

feature -- Rels Definitions

	rel_api_admin_roles: STRING = "[
			<!DOCTYPE html>
			<html>
			<head>
				<link href="/rels.css" media="all" rel="stylesheet" type="text/css">
			</head>
			<body>
			<h1 class="page-header">Api-admin-roles <small>relation</small> </h1>
			
			<div class="well method"><h2>GET</h2>
				<p class="description">Fetch a list of roles</p>
			
				<div class="response"><h3>Responses</h3>
					<div class="code">
						<h4>200 OK</h4>
						<div class="body">
							<h5>Body</h5>
							<div class="links"><h6>LINKS</h6>
								<ul>
									<li><a href="/api/rels/api-admin-roles">ht:api-admin-roles</a> - an array of roles links (REQUIRED)</li>
									<li>next (OPTIONAL)</li>
									<li>prev (OPTIONAL)</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="well method"><h2>POST</h2>
				<p class="description">Create a new Role</p>
			
				<div class="request"><h3>Responses</h3>
					<div class="headers">
						<h4>Request Headers</h4>
						<div class="type">
							The request should have the Content-Type application/json
						</div>
					</div>
			
					<div class="body">
						<h4>Body</h4>
						<div class="required">
							<h5>Required properties</h5>
							<ul>
								<li><stong>name</strong> : "The string containing the name of the role"
								</li>
							</ul>
							<h5>Example</h5>
							<pre>
					"{
						"name": "users"
					}"
							</pre>
						</div>
					</div>
				</div>
				<div class="response">
			    	<h3>Responses</h3>
			    	<div class="code">
			      	<h4>201 Created</h4>
			    	  <div class="headers">
			       	 <h5>Headers</h5>
			       	 <ul>
			          <li>Location: URI of the created <a href="/api/rels/api-admin-roles">Role</a></li>
			        </ul>
			      </div>
			    </div>
			    <div class="code">
			      <h4>401 Unauthorized</h4>
			      <div class="headers">
			        <h5>Headers</h5>
			        <ul>
			          <li>WWW-Authenticate: indicates the Auth method (typically HTTP Basic)</li>
			        </ul>
			      </div>
			    </div>
			  </div>
			</div>
			</body>
			</html>
		]"

	rel_api_role_permissions: STRING = "[
						<!DOCTYPE html>
						<html>
						<head>
							<link href="/rels.css" media="all" rel="stylesheet" type="text/css">
						</head>
						<body>
						<h1 class="page-header">api-role-permission <small>relation</small> </h1>
			
						<div class="well method"><h2>GET</h2>
							<p class="description">Fetch a list of permission for the current role</p>
			
							<div class="response"><h3>Responses</h3>
								<div class="code">
									<h4>200 OK</h4>
									<div class="body">
										<h5>Body</h5>
										<div class="links"><h6>LINKS</h6>
											<ul>
												<li><a href="/api/rels/api-role-permissions">ht:api-role-permissions</a> - an array of permissions for a given role (REQUIRED)</li>
												<li>next (OPTIONAL)</li>
												<li>prev (OPTIONAL)</li>
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
			
						<div class="well method"><h2>POST</h2>
							<p class="description">Create a new Permission</p>
			
							<div class="request"><h3>Responses</h3>
								<div class="headers">
									<h4>Request Headers</h4>
									<div class="type">
										The request should have the Content-Type application/json
									</div>
								</div>
			
								<div class="body">
									<h4>Body</h4>
									<div class="required">
										<h5>Required properties</h5>
										<ul>
											<li><stong>name</strong> : "The string containing the name of the Permission"
											</li>
										</ul>
										<h5>Example</h5>
										<pre>
								"{
									"name": "edit something"
								}"
										</pre>
									</div>
								</div>
							</div>
							<div class="response">
						    	<h3>Responses</h3>
						    	<div class="code">
						      	<h4>201 Created</h4>
						    	  <div class="headers">
						       	 <h5>Headers</h5>
						       	 <ul>
						          <li>Location: URI of the created <a href="/api/rels/api-role-permissions">Permission</a></li>
						        </ul>
						      </div>
						    </div>
						    <div class="code">
						      <h4>401 Unauthorized</h4>
						      <div class="headers">
						        <h5>Headers</h5>
						        <ul>
						          <li>WWW-Authenticate: indicates the Auth method (typically HTTP Basic)</li>
						        </ul>
						      </div>
						    </div>
						  </div>
						</div>

						</body>
						</html>
		]"

	rel_api_role_update: STRING = "[
						<!DOCTYPE html>
						<html>
						<head>
							<link href="/rels.css" media="all" rel="stylesheet" type="text/css">
						</head>
						<body>
						<h1 class="page-header">api-role-update <small>relation</small> </h1>
			
						<div class="well method"><h2>PUT</h2>
							<p class="description">Update the current role</p>
							<div class="request"><h3>Responses</h3>
								<div class="headers">
									<h4>Request Headers</h4>
										<div class="type">
											The request should have the Content-Type application/json
										</div>
								</div>
							<div class="body">
								<h4>Body</h4>
									<div class="required">
										<h5>Required properties</h5>
										<ul>
											<li><stong>name</strong> : "The string containing the new name of the role"
										</li>
										</ul>
											<h5>Example</h5>
										<pre>
										"{
											"name": "users"
										}"
										</pre>
										</div>
									</div>
							</div>

								<div class="code">
									<h4>204 No Content</h4>
								</div>
						    </div>
						    <div class="code">
						      <h4>401 Unauthorized</h4>
						      <div class="headers">
						        <h5>Headers</h5>
						        <ul>
						          <li>WWW-Authenticate: indicates the Auth method (typically HTTP Basic)</li>
						        </ul>
						      </div>
						    </div>
						  </div>
						</div>
						</div>
					</body>
					</html>
		]"

	rel_api_role_delete: STRING = "[
						<!DOCTYPE html>
						<html>
						<head>
							<link href="/rels.css" media="all" rel="stylesheet" type="text/css">
						</head>
						<body>
						<h1 class="page-header">api-role-delte <small>relation</small> </h1>
			
						<div class="well method"><h2>DELETE</h2>
							<p class="description">Delete the current role</p>
			
							<div class="response"><h3>Responses</h3>
								<div class="code">
									<h4>204 No Content</h4>
								</div>
							</div>
						    <div class="code">
						      <h4>401 Unauthorized</h4>
						      <div class="headers">
						        <h5>Headers</h5>
						        <ul>
						          <li>WWW-Authenticate: indicates the Auth method (typically HTTP Basic)</li>
						        </ul>
						      </div>
						    </div>
						  </div>
						</div>
						</div>
					</body>
					</html>
		]"

feature -- {NONE}

	compute_response_get (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING; media_type: STRING)
		local
			h: HTTP_HEADER
			l_msg: STRING
			hdate: HTTP_DATE
		do
			create h.make
			create l_msg.make_from_string (output)
			h.put_content_type (media_type)
			h.put_content_length (l_msg.count)
			if attached req.request_time as time then
				create hdate.make_from_date_time (time)
				h.add_header ("Date:" + hdate.rfc1123_string)
			end
			res.set_status_code ({HTTP_STATUS_CODE}.ok)
			res.put_header_text (h.string)
			res.put_string (l_msg)
		end

end
