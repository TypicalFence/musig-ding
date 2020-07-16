package main

import (
	"container/list"
	"flag"
	"fmt"
	"github.com/gorilla/websocket"
	"gopkg.in/mgo.v2/bson"
	"log"
	"net"
	"net/http"
	"os"
)

const _SockAddr = "/tmp/socks.sock"

var (
	addr    = flag.String("addr", "127.0.0.1:8080", "http service address")
	cmdPath string
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}
var queue = list.New()

func handleWebsocket(w http.ResponseWriter, r *http.Request) {
	// evil cross origin hack lol
	upgrader.CheckOrigin = func(r *http.Request) bool { return true }
	conn, sock_err := upgrader.Upgrade(w, r, nil)

	if sock_err != nil {
		println("could not open socket, or something, who knows")
		return
	}

	for {
		element := queue.Front()
		if element == nil {
			continue
		}

		fmt.Printf("%+v\n", element.Value)

		err := conn.WriteJSON(element.Value)
		queue.Remove(element)

		if err != nil {
			return
		}
	}
}

func handleSystemsocket(c net.Conn) {
	for {
		buf := make([]byte, 1024)
		nr, err := c.Read(buf)
		if err != nil {
			return
		}

		data := buf[0:nr]
		var bsonObject bson.M
		bson.Unmarshal(data, &bsonObject)
		queue.PushBack(bsonObject)
	}
}

func main() {
	flag.Parse()

	// create and open websocket
	http.HandleFunc("/ws", handleWebsocket)

	go func() {
		log.Fatal(http.ListenAndServe(*addr, nil))
	}()

	// create and open unixsocket
	if err := os.RemoveAll(_SockAddr); err != nil {
		log.Fatal(err)
	}

	l, err := net.Listen("unix", _SockAddr)
	if err != nil {
		log.Fatal("listen error:", err)
	}
	defer l.Close()

	for {
		conn, err := l.Accept()
		if err != nil {
			log.Fatal("accept error:", err)
		}

		go handleSystemsocket(conn)
	}
}
