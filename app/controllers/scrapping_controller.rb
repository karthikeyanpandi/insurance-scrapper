class ScrappingController < ApplicationController
	
	def index
		@results = []
	end

	def create 

	end

	def pull_data
    p "111111111111"
    scrapping = ScrapperService.new(params)
    @results, export_final_data = scrapping.fetch_data()
    scrapping.export_csv_file(export_final_data)
		#@results = [{"Ref/Acct No."=>" 011088880001", "Member ID"=>"  210022554", "Member Name"=>" DANZEL CAVER", "Member DOB"=>" 11/26/1983", "Servicing Provider"=>" JACKSON PARK HOSPITAL IL", "Servicing NPI"=>" 1497750699", "DOS Range"=>" 11/10/2017 - 11/12/2017"},{"Ref/Acct No."=>" 011088880001", "Member ID"=>"  210022554", "Member Name"=>" DANZEL CAVER", "Member DOB"=>" 11/26/1983", "Servicing Provider"=>" JACKSON PARK HOSPITAL IL", "Servicing NPI"=>" 1497750699", "DOS Range"=>" 11/10/2017 - 11/12/2017"}]
	end
end
