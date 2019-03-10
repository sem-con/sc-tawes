module DataAccessHelper
    def getData(params)
        require 'open-uri'
        require 'csv'

        if (params["id"].to_s != "")
        	response = open('https://www.zamg.ac.at/ogd/').string.force_encoding("utf-8") rescue nil
        	if !response.nil?
        		CSV.parse(response, headers: true, col_sep: ";").each do |row|
        			if row["Station"].to_s == params["id"].to_s
        				return [
        					response.split("\n").first,
        					row.to_csv(col_sep: ";").strip
        				]
        			end
        		end
        		[]
        	else
        		[]
        	end
        else 
        	open('https://www.zamg.ac.at/ogd/').string.force_encoding("utf-8").split("\n") rescue []
        end

    end
end