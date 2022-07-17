require 'socket'

class WebServer
  PORT = ENV.fetch('PORT', 3000)
  HOST = ENV.fetch('HOST', '127.0.0.1').freeze
  SOCKET_READ_BACKLOG = ENV.fetch('TCP_BACKLOG', 12).to_i

  def serve
    puts "=== サーバーを起動します ===\n\n"

    begin 
      socket = TCPServer.new(HOST, PORT)
      socket.listen(SOCKET_READ_BACKLOG)
  
      puts "=== クライアントからの接続を待ちます ===\n\n"
      conn, _addr_info = socket.accept 
      puts "=== クライアントとの接続が完了しました ===\n\n"
  
      request = ""
      while buf = conn.gets 
        request << buf
        break if buf.chomp.empty?
      end
      puts request 
  
      response_body = "<html><body><h1>It works!</h1></body></html>"
      response_line = "HTTP/1.1 200 OK\r\n"
  
      response_header = ""
      response_header << "Date: #{Time.now}\r\n"
      response_header << "Host: FumiServer/0.1\r\n"
      response_header << "Content-Length: #{response_body.size}\r\n"
      response_header << "Connection: Close\r\n"
      response_header << "Content-Type: text/html\r\n"
  
      response = response_line + response_header + "\r\n" + response_body 
      puts response + "\n\n"
  
      conn.puts response
  
    ensure
      puts "=== サーバーを停止します ===\n\n"
      conn.close 
      socket.close
    end
  end

end

