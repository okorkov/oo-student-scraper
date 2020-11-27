require 'open-uri'
require 'pry'
require 'nokogiri'


class Scraper

  def self.scrape_index_page(index_url)
    profiles = []
    html = open(index_url)
    doc = Nokogiri::HTML(html) 
    students = doc.css(".student-card")
    students.each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      href = student.at_css('a')
      link = href['href']
      profiles.push(name: name, location: location, profile_url: link)
    end
    profiles
  end

  def self.scrape_profile_page(profile_url)
    profile = {}
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    profile_quote = doc.css('.profile-quote').text
    bio = doc.css(".description-holder p").text
    twitter = nil
    linkedin = nil
    github = nil
    blog = nil
    media_array = []
    social_media = doc.css('.social-icon-container a')
    social_media.each do |media|
      media_array << media['href']
    end
    media_array.each do |link|
      if link.include?('twitter.com')
        twitter = link
      elsif link.include?('linkedin.com')
        linkedin = link
      elsif link.include?('github.com')
        github = link
      else
        blog = link
      end
    end

    if bio != nil
      profile[:bio] = bio
    end
    if blog != nil
      profile[:blog] = blog
    end
    if twitter != nil
      profile[:twitter] = twitter
    end
    if linkedin != nil
      profile[:linkedin] = linkedin
    end
    if profile_quote != nil
      profile[:profile_quote] = profile_quote
    end
    if github != nil
      profile[:github] = github
    end
   profile
  end

end

