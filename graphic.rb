require "gruff"

class Graphic
  def initialize(input = 'test.log', output = 'graphic.png')
    @line_num, @urls = 0, []
    @s, @ips, @output = [], [], output
    read_file(input)
    set_addresses
  end

  def read_file(input)
    text = File.open(input).read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |e|
      @urls << e
      @line_num += 1
    end
  end

  def set_addresses
    @urls.each_with_index do |e, i|
      @s << e.split(' ')
    end
    @s.each_with_index do |e, i|
      @ips << e[0]
    end
    @ips = @ips.uniq.compact
  end

  def get_labels
    labels = Hash[(0..@ips.size-1).zip @ips]
    labels
  end

  def get_points
    (0..@ips.size-1).collect { |i| rand(100) }
  end

  def plot
    g = Gruff::Line.new(2000)
    g.title = 'requests'
    g.theme = {
      :colors => ['#3B5998'],
      :marker_color => 'silver',
      :font_color => '#333333',
      :background_colors => ['white', 'silver'],
      
    }
    g.labels = get_labels
    g.data(:network, get_points)
    g.write(@output)
    puts 'Complete.'
  end
  
end

c = Graphic.new
c.plot