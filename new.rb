#!/usr/bin/env ruby

require "net/http"
require "benchmark"

class New

  def initialize (file = 'urls.txt', num = 2, requests = 10)
    @line_num = 0
    @url = []
    text = File.open(file).read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |e|
      @url << e
      @line_num += 1
    end
    @requests, @num, @threads = requests, num, []
    @n = requests/num
  end
  
  def go_get
    Benchmark.bm do |x|
      x.report("get:\n") {
        @num.times do |i|
          @threads[i] = Thread.new {
            @url.each do |u|
              @n.times do
                uri = URI.parse u
                http = Net::HTTP.new uri.host, uri.port
                req = Net::HTTP::Get.new uri.path, {'User-Agent' => 'web-bench tool test'}
                res = http.request req
                puts u.gsub("\n",'') + ' - ' + res.code + ' ' + res.message + "\n"
              end
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
