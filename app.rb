# app.rb
require "unloosen"
require 'uri'

content_script site: "www.example.com" do
    h1 = document.getElementsByTagName("h1")[0]
    h1.innerText = "Unloosen Example Page!"

  window.addEventListener('keydown') do |e|
      # // Control + G

      if e.ctrlKey && e.keyCode == 71
        url = window.getSelection.toString;
        if url.length > 0
          puts url
          chrome.runtime.sendMessage(JS.try_convert_hash({ message: url }))
          # chrome.runtime.sendMessage(url)
        end
      end
  end
end

handleMessage = Proc.new do |request, sender, sendResponse|
  if sender.tab # && request.message
    url = "https://www.google.co.jp/search?q=#{URI.encode_www_form_component(request.message)}"
    chrome.tabs.create(JS.try_convert_hash({ url: url }))
  end
end

# function handleMessage(request, sender, sendResponse) {
#   if (sender.tab && request.message !== undefined) {
#     const url = `https://www.google.co.jp/search?q=${encodeURIComponent(
#       request.message
#     )}`;
#     browser.tabs.create({ url: url }, tab => {});
#   }
# }

# browser.runtime.onMessage.addListener(handleMessage);

background do
  puts 'loaded'
  chrome.runtime.onMessage.addListener(handleMessage)
end
