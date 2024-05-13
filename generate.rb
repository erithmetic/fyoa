require 'bundler/setup'

require 'json'
require 'prawn'
require 'rqrcode'

URL = ENV.fetch('URL', 'http://localhost:4567')
NUMBER = '3168540132'

gopher = JSON.parse(File.read('gopher.json'))

def generate_qrcode(number, id)
  qrcode = RQRCode::QRCode.new("#{URL}/story/#{id}/#{number}")
  png = qrcode.as_png
  path = File.join("pdfs/#{id}.png")
  IO.binwrite path, png.to_s
  path
end

def generate_pdf(number, id, story)
  path = File.join("pdfs/story-#{id}.pdf")

  pdf = Prawn::Document.new

  pdf.font 'Courier'

  pdf.font_size 24
  pdf.text 'FAX YOUR OWN ADVENTURE'
  pdf.text ' '

  pdf.font_size 20
  pdf.text story['title']
  pdf.text ' '

  pdf.font_size 12
  story['story'].each do |paragraph|
    pdf.text paragraph
    pdf.text ' '
  end

  if story['options'].any? then
    pdf.font_size 16
    pdf.text 'CHOICES'
    pdf.text ' '
  end

  pdf.font_size 12
  story['options'].each_with_index do |option, i|
    num = i + 1
    pdf.text "Choice #{num}: " + option['text']
    qr_code_path = generate_qrcode number, option['arc']
    pdf.image qr_code_path
    pdf.text "Scan QR code above to choose option #{num}"
    pdf.text ' '
  end

  pdf.render_file(path)
  path
end

gopher.each do |id, story|
  path = generate_pdf NUMBER, id, story
  puts path
end