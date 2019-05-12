module DataAccessHelper
    def getData(params)
        require 'open-uri'
        require 'csv'

        retVal = []
        if (params["id"].to_s != "")
        	response = open('https://www.zamg.ac.at/ogd/').string.force_encoding("utf-8") rescue nil
        	if !response.nil?
        		CSV.parse(response, headers: true, col_sep: ";").each do |row|
                    if JSON.parse("[" + params["id"].to_s + "]").map(&:to_s).include? row["Station"].to_s
                        if retVal.count == 0
                            retVal << response.split("\n").first
                        end
        				retVal << row.to_csv(col_sep: ";").strip
        			end
        		end
        	end
            retVal
        else 
        	open('https://www.zamg.ac.at/ogd/').string.force_encoding("utf-8").split("\n") rescue []
        end
    end

    def get_provision(params, logstr)
        retVal_type = container_format
        timeStart = Time.now.utc
        retVal_data = getData(params)
        timeEnd = Time.now.utc
        content = []
        case retVal_type.to_s
        when "JSON"
            retVal_data.each { |item| content << JSON(item) }
            content = content
            content_hash = Digest::SHA256.hexdigest(content.to_json)
        when "RDF"
            retVal_data.each { |item| content << item.to_s }
            content_hash = Digest::SHA256.hexdigest(content.to_s)
        else
            content = retVal_data.join("\n")
            content_hash = Digest::SHA256.hexdigest(content.to_s)
        end
        param_str = request.query_string.to_s

        createLog({
            "type": logstr,
            "scope": "all (" + retVal_data.count.to_s + " records)",
            "request": request.remote_ip.to_s}.to_json)

        {
            "content": content,
            "usage-policy": container_usage_policy.to_s,
            "provenance": getProvenance(content_hash, param_str, timeStart, timeEnd)
        }.stringify_keys
    end

end