module ProvenanceActivityHelper
	def getProvenanceActivity(data_hash, container_uid, param_str, timeStart, timeEnd)

        init = RDF::Repository.new()
        init << RDF::Reader.for(:trig).new(Semantic.first.validation.to_s)
        bc = nil
        init.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "BaseConfiguration" ? bc = g : nil }
        source_description = RDF::Query.execute(bc) { pattern [:subject, RDF::URI.new(SEMCON_ONTOLOGY + "hasDataLocationDescription"), :value] }.first.value.to_s rescue ""
        source_url = RDF::Query.execute(bc) { pattern [:subject, RDF::URI.new(SEMCON_ONTOLOGY + "hasDataLocation"), :value] }.first.value.to_s rescue ""
		source_hash = Digest::SHA256.hexdigest(
			source_description + " <" + source_url + ">")

		prov  = "scr:input_" + data_hash[0,12] + "_" + container_uid[0,8] + " a prov:Activity;\n"
		prov += '    rdfs:label "' + data_hash + '"^^xsd:string;' + "\n"
		prov += "    prov:qualifiedUsage [\n"
		prov += "        a prov:Usage;\n"
		prov += "        prov:entity scr:source_" + source_hash[0,12] + ";\n"
		prov += '        rdfs:comment "' + param_str + '"^^xsd:string;' + "\n"
		prov += "    ];\n"
		prov += '    prov:startedAtTime "' + timeStart.iso8601 + '"^^xsd:dateTime;' + "\n"
		prov += '    prov:endedAtTime "' + timeEnd.iso8601 + '"^^xsd:dateTime;' + "\n"
		prov += "    prov:generated scr:data_" + data_hash[0,12] + "_" + container_uid[0,8] + ";\n"
		prov += ".\n\n"

		prov += "scr:source_" + source_hash[0,12] + " a prov:Entity;\n"
		prov += '    rdfs:label "' + source_hash + '"^^xsd:string;' + "\n"
		prov += "    a prov:PrimarySource;\n"
		prov += '    rdfs:comment "' + source_description + '"^^xsd:string;' + "\n"
		prov += "    prov:hasLocation <" + source_url + ">;\n"
		prov += ".\n\n"

		prov

	end
end
