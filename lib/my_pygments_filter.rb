require 'pygments'
require 'nokogiri'
require 'fileutils'
require 'digest/md5'

PYGMENTS_CACHE_DIR = File.expand_path('../../.pygments-cache', __FILE__)
FileUtils.mkdir_p(PYGMENTS_CACHE_DIR)

class MyPygmentsFilter < Nanoc3::Filter
  identifier :my_pygments

  def run(content, params={})
    klass = Nokogiri::HTML
    doc = klass.fragment(content)
    
    doc.css('code').each do |element|
      # Get language
      has_class = false
      language = nil
      if element['class']
        # Get language from class
        match = element['class'].match(/(^| )language-([^ ]+)/)
        language = match[2] if match
        has_class = true if language
      else
        # Get language from comment line
        match = element.inner_text.match(/^#!([^\n]+)$/)
        language = match[1] if match
        element.content = element.content.sub(/^#!([^\n]+)$\n/, '') if language
      end
    
      next if language.nil?

      highlighted_code = highlight(element.inner_text.strip, language)
      element.inner_html = highlighted_code.strip
    end

    doc.to_html(:encoding => 'UTF-8')
  end

  def highlight(str, lang)
    lang = 'ruby' if lang == 'ru'
    lang = 'objc' if lang == 'm'
    lang = 'perl' if lang == 'pl'
    lang = 'yaml' if lang == 'yml'
    str = pygments(str, lang).match(/<pre>(.+)<\/pre>/m)[1].to_s.gsub(/ *$/, '') #strip out divs <div class="highlight">
    tableize_code(str, lang)
  end

  def pygments(code, lang)
    if defined?(PYGMENTS_CACHE_DIR)
      path = File.join(PYGMENTS_CACHE_DIR, "#{lang}-#{Digest::MD5.hexdigest(code)}.html")
      if File.exist?(path)
        highlighted_code = File.read(path)
      else
        highlighted_code = Pygments.highlight(code, :lexer => lang, :formatter => 'html', :options => {:encoding => 'utf-8'})
        File.open(path, 'w') {|f| f.print(highlighted_code) }
      end
    else
      highlighted_code = Pygments.highlight(code, :lexer => lang, :formatter => 'html', :options => {:encoding => 'utf-8'})
    end

    highlighted_code
  end
  
  def tableize_code (str, lang = '')
    table = '<div class="highlight"><table><tr><td class="gutter"><pre class="line-numbers">'
    code = ''
    str.lines.each_with_index do |line,index|
      table += "<span class='line-number'>#{index+1}</span>\n"
      code  += "<span class='line'>#{line}</span>"
    end
    table += "</pre></td><td class='code'><pre><code class='#{lang}'>#{code}</code></pre></td></tr></table></div>"
  end
end

