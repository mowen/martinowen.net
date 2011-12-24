require 'nokogiri'
require 'uv'

class UltravioletFilter < Nanoc3::Filter
  identifier :uv
  
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

      # Highlight
      highlighted_code = Uv.parse(element.inner_text.strip, "xhtml", language, params[:line_numbers], params[:theme])
      element.inner_html = highlighted_code.strip
    end

    doc.to_html(:encoding => 'UTF-8')
  end

end
