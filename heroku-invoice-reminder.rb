#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

$:.push "."

require 'rubygems'
require 'bundler'
Bundler.require :default

require 'heroku/command/base'
require 'heroku-invoice/lib/invoice/heroku/client'
require 'heroku-invoice/lib/invoice/heroku/command/invoice'

config = Pit.get('heroku-invoice-reminder', :require => {
    :user_name => 'your username',
    :password => 'your password',
    :address => 'smtp.gmail.com',
    :port => 587,
    :to => 'your reminder address',
  })

Heroku::Command::Invoice.new.pdf

Mail.defaults { delivery_method :smtp, config }
Mail.deliver do
  from config[:user_name]
  to config[:to]
  cc config[:cc]
  subject "Heroku invoice reminder #{Time.now.strftime('%Y%m')}"
  body ''
  add_file({:filename => "#{Time.now.strftime('%Y%m')}.pdf"})
end

FileUtils.rm "#{Time.now.strftime('%Y%m')}.pdf"
