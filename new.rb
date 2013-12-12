#!/usr/bin/env ruby

require "net/http"
require "benchmark"

class New

  def initialize (url = 'http://127.0.0.1/', num = 8, requests = 5000)
    @url = url
    @requests, @num, @threads = requests, num, []
    @n = requests/num
  end
  
  def go_get
    Benchmark.bm do |x|
      x.report("get:") {
        @num.times do |i|
          @threads[i] = Thread.new {
            @n.times do
              uri = URI.parse @url
              http = Net::HTTP.new uri.host, uri.port
              req = Net::HTTP::Get.new uri.path, {'User-Agent' => 'web-bench tool test'}
              res = http.request req
            end
          }
        end
        @threads.each { |e| e.join }
      }
    end
  end
  
  def go_post data
    Benchmark.bm do |x|
      x.report("get:") {
        @num.times do |i|
          @threads[i] = Thread.new {
            @n.times do
              uri = URI.parse @url
              http = Net::HTTP.new uri.host, uri.port
              req = Net::HTTP::Post.new uri.path, {'User-Agent' => 'web-bench tool test'}
              req.body = data
              res = http.request req
            end
          }
        end
        @threads.each { |e| e.join }
      }
    end
  end
end