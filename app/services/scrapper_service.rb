require 'selenium-webdriver'
require "watir-webdriver"
require "date"
require 'csv'
require 'iconv'


class ScrapperService
  def initialize(params)
    @filterFormdata = []
    if params[:file].present?
      csv = File.read(params[:file].path)
      CSV.parse(csv, headers: true).each do |row|
        @filterFormdata << {fromdate: row['fromdate'].strip, todate: row['todate'].strip, memberid: row['memberid'].strip}
        params.merge!(username: row['username'], password: row['password']) if row['username'].present?
      end
    else
      from_date_parse = Date.strptime("#{params[:fromdate].join('- ')}", '%Y-%m-%d')
      start_date = from_date_parse.strftime('%d/%m/%Y')
      end_date_parse = Date.strptime("#{params[:todate].join('- ')}", '%Y-%m-%d')
      to_date = end_date_parse.strftime('%d/%m/%Y')
    end
    @signIn={ email: params[:username], password: params[:password] }
    #@filterForm={ from_date: start_date, end_date: to_date, member_id: params[:memberid] }
    @browser = Watir::Browser.new

  end

  def fetch_data
    @browser.goto "https://provider.illinicare.com/sso/login?service=https%3A%2F%2Fprovider.illinicare.com%2Fcareconnect%2Fj_spring_cas_security_check"
    @browser.text_field(:id, "username").set @signIn[:email]
    @browser.text_field(:id, "password").set @signIn[:password]
    @browser.button(:type,"submit").click
    data = main_page?
  end

  def close_browser?
    @browser.close
  end

  def login_page?
    @browser.a(:class,"claims").present?
  end


  def main_page?
    if login_page? != true
      close_browser?
      errors = {}
      data = errors.merge(msg:"Invalid username or password")
    else
      @browser.a(:class,"claims").click


      p "@filterFormdata@filterFormdata@filterFormdata@filterFormdata@filterFormdata"

      p @filterFormdata
      urls = []

      @filterFormdata.each do |filter|
        p "filterrrrrrrr"
        p filter[:fromdate]
        @browser.button(:id, "filter-button").click
        @browser.execute_script("document.getElementById('dosFrom').value=#{filter[:fromdate]}")
        @browser.execute_script("document.getElementById('dosTo').value=#{filter[:todate]}")
        from_date = "$('#dosFrom').val('#{filter[:fromdate]}')"
        end_date = "$('#dosTo').val('#{filter[:todate]}')"

        @browser.execute_script(from_date)
        #@browser.execute_script('$("#dosFrom").val()', filter[:fromdate])
        #@browser.execute_script('$("#dosFrom").val("11/10/2017")')
        @browser.execute_script(end_date)
        #@browser.execute_script('$("#dosTo").val("11/12/2017")')
        @browser.text_field(:id, "memberMedicaidId").set filter[:memberid]
        @browser.form(:id,'claimStatusModel').submit
        if @browser.table.tbody.present?
          @browser.table.tbody.trs.each do |tr|
            claim_url = {"#{tr.a.text}": "#{tr.a.href}"}
            urls << claim_url
          end
        end
      end
      p "urlssssssssssss"
      p urls
      data  = fetch_table_data(urls)
    end
  end

  def fetch_table_data(urls)
    key_value_data = []
    final_key_value = []
    urls.each do |url|
      @browser.goto url.values.first
      class_name = ["size1of2", "size2of2"]
      class_name.each do |name|
        data = @browser.div(:class,"#{name}").text
        split_data = data.split("\n")
        split_data.each do |s|
          key_value_data << s.split(":")
        end
      end
      final_data = key_value_data.to_h
      final_key_value.push({"#{url.keys.first}"=> final_data })
    end
    close_browser?
    final_key_value
  end

end
