module DataAccessHelper
    def getData(params)
        require 'open-uri'
        require 'csv'

        open('https://www.zamg.ac.at/ogd/').string.force_encoding("utf-8").split("\n") rescue []

    end
end