#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$:.push "."
$:.push "./heroku-invoice/lib"

require 'rubygems'
require 'bundler'
Bundler.require :default

config = Pit.get('heroku-invoice-reminder', :require => {
    :user_name => 'your username',
    :password => 'your password',
    :address => 'smtp.gmail.com',
    :port => 587,
    :to => 'your reminder address',
  })

now = (Time.now - 30*24*60*60).strftime('%Y%m')

system("heroku invoice:pdf #{now}")

Mail.defaults { delivery_method :smtp, config }
Mail.deliver do
  from config[:user_name]
  to config[:to]
  cc config[:cc]
  subject "Heroku invoice reminder #{now}"
  body ''
  add_file({:filename => "#{now}.pdf"})
end

FileUtils.rm "#{now}.pdf"
