require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_info=[]
    doc = Nokogiri::HTML(open(index_url)) 
    students = doc.css(".student-card")
    students.each do |student|
      student_info << {
      :name =>student.search(".student-name").text,
      :location=>student.search(".student-location").text,
      :profile_url=>student.search("a").first["href"]
      }
    end
    student_info
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url)) 
    profile_info={}
      links=doc.css(".social-icon-container a").collect {|link| link.attributes["href"].value}
      links.each do |link|
        if link.include?("twitter") 
          profile_info[:twitter]= link
        elsif link.include?("linkedin")
          profile_info[:linkedin]= link
        elsif link.include?("github")
          profile_info[:github]= link
        else
          profile_info[:blog]= link
        end
      end
      profile_info[:profile_quote]= doc.css(".profile-quote").text
      profile_info[:bio]= doc.css(".description-holder p").text
      profile_info
  end
end