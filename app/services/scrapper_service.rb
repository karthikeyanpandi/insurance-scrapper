require 'selenium-webdriver'
require "watir-webdriver"

class ScrapperService
  def initialize(params)
    @signIn={
        email: "ralkhatib@mbosinc.com",
        password: "Letmein2"
    }

    @filterForm={
        from_date: "11/10/2017",
        end_date: "11/12/2017",
        member_id: "210022554"
    }
    #@signIn={ email: params[:username], password: params[:password] }
    #@filterForm={ from_date: params[:from_date], end_date: params[:from_date], member_id: params[:memberid] }
    @browser = Watir::Browser.new
  end

  def fetch_data
    @browser.goto "https://provider.illinicare.com/sso/login?service=https%3A%2F%2Fprovider.illinicare.com%2Fcareconnect%2Fj_spring_cas_security_check"
    @browser.text_field(:id, "username").set @signIn[:email]
    @browser.text_field(:id, "password").set @signIn[:password]
    @browser.button(:type,"submit").click
    result =[]
    data = main_page?
    result << data
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
      @browser.button(:id, "filter-button").click
      @browser.execute_script('$("#dosFrom").val("11/10/2017")')
      @browser.execute_script('$("#dosTo").val("11/12/2017")')
      @browser.text_field(:id, "memberMedicaidId").set @filterForm[:member_id]
      @browser.form(:id,'claimStatusModel').submit
      urls = []
      @browser.table.tbody.trs.each do |tr|
        claim_url = {"#{tr.a.text}": "#{tr.a.href}"}
        urls << claim_url
      end
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
