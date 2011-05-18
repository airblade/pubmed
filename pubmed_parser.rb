#!/usr/bin/env ruby
#
# Parses PubMed baseline XML files.
#
# Each data file contains 30,000 records and is ~165MB.  We parse the
# XML as a stream rather than a tree for speed and low memory use.
#
# Rather than code our own SAX parser, which would be messy and error-
# prone, we use SAX Machine.  Its parsing is almost as fast, and the code
# is far cleaner.

require 'rubygems'
require 'nokogiri'
require 'sax-machine'
require 'date'
require 'awesome_print'

def log(msg)
  puts "#{Time.now}: #{msg}"
end

class SomeDate  # avoid namespace clash with Date
  include SAXMachine
  element :Year,  :as => :year
  element :Month, :as => :month
  element :Day,   :as => :day
  def to_s(format = '%Y-%m-%d')
    Date.new(year.to_i, month.to_i, day.to_i).strftime(format)
  end
end

class PublicationDate
  include SAXMachine
  element :MedlineDate, :as => :medline_date
end

class JournalIssue
  include SAXMachine
  element :Volume,  :as => :volume
  element :Issue,   :as => :issue
  element :PubDate, :as => :publication_date, :class => PublicationDate
end

class Pagination
  include SAXMachine
  element :MedlinePgn, :as => :medline_pagination
end

class Journal
  include SAXMachine
  element :Title,           :as => :title
  element :ISOAbbreviation, :as => :iso_abbreviation
  element :JournalIssue,    :as => :journal_issue, :class => JournalIssue
end

class Abstract
  include SAXMachine
  element :AbstractText, :as => :objective,   :with => {:Label => 'OBJECTIVE'}
  element :AbstractText, :as => :_methods,    :with => {:Label => 'METHODS'}  # avoid namespace clash with :methods
  element :AbstractText, :as => :results,     :with => {:Label => 'RESULTS'}
  element :AbstractText, :as => :conclusions, :with => {:Label => 'CONCLUSIONS'}
end

class Article
  include SAXMachine
  element :ArticleTitle, :as => :title
  element :Journal,      :as => :journal,    :class => Journal
  element :Pagination,   :as => :pagination, :class => Pagination
  element :Abstract,     :as => :abstract,   :class => Abstract
end

class MedLineCitation
  include SAXMachine
  element :PMID,          :as => :pmid
  element :DateCreated,   :as => :created_on,   :class => SomeDate
  element :DateCompleted, :as => :completed_on, :class => SomeDate
  element :Article,       :as => :article,      :class => Article
end

class MedLineCitationSet
  include SAXMachine
  elements :MedlineCitation, :as => :citations, :class => MedLineCitation
end


file = ARGV[0]
citation_set = MedLineCitationSet.parse File.read(file)
citation_set.citations.each do |citation|
  attrs = ({
    :pmid             => citation.pmid,
    :created_on       => citation.created_on.to_s,
    :completed_on     => citation.completed_on.to_s,

    :journal_title    => citation.article.journal.title,
    :iso_abbreviation => citation.article.journal.iso_abbreviation,
    :volume           => citation.article.journal.journal_issue.volume,
    :issue            => citation.article.journal.journal_issue.issue,
    :publication_date => citation.article.journal.journal_issue.publication_date.medline_date,

    :pages            => citation.article.pagination.medline_pagination,
    :article_title    => citation.article.title,
    :objective        => citation.article.abstract.objective,
    :methods          => citation.article.abstract._methods,
    :results          => citation.article.abstract.results,
    :conclusions      => citation.article.abstract.conclusions
  })
  ap attrs
end
