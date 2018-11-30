require 'selenium-webdriver'
require "watir-webdriver"

class ScrapperService
  def initialize()
    @signIn={ email: "ralkhatib@mbosinc.com", password: "Letmein2" }
    @filterForm={ from_date: "11/10/2017", end_date: "11/12/2017", member_id: "210022554" }
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


  def main_page?
    @browser.a(:class,"claims").click
    @browser.button(:id, "filter-button").click
    @browser.execute_script('$("#dosFrom").val("11/10/2017")')
    @browser.execute_script('$("#dosTo").val("11/12/2017")')
    @browser.text_field(:id, "memberMedicaidId").set @filterForm[:member_id]
    @browser.form(:id,'claimStatusModel').submit
    urls = []
    row = @browser.table.tbody.trs.find do |tr|
      urls << tr.a.href
    end

    data  = fetch_table_data(urls)
  end

  def fetch_table_data(urls)
    urls.each do |u|
      @browser.goto u
    end
    fetch_final_result
  end

  def fetch_final_result
    class_name = ["size1of2", "size2of2"]
    key_value_data = []
    class_name.each do |name|
      data = @browser.div(:class,"#{name}").text
      split_data = data.split("\n")
      split_data.each do |s|
        key_value_data << s.split(":")
      end
    end
    final_data = key_value_data.to_h
    @browser.close
    final_data
  end

end
