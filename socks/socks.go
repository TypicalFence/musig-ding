package main

import (
	"container/list"
	"fmt"
	"github.com/gorilla/websocket"
	"github.com/mbndr/figlet4go"
	"gopkg.in/mgo.v2/bson"
	"log"
	"net"
	"net/http"
	"os"
	"strconv"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}
var queue = list.New()

func handleWebsocket(w http.ResponseWriter, r *http.Request) {
	// evil cross origin hack lol
	upgrader.CheckOrigin = func(r *http.Request) bool { return true }
	conn, sockErr := upgrader.Upgrade(w, r, nil)

	if sockErr != nil {
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
		println("recieved: " + bsonObject["kind"].(string))
		queue.PushBack(bsonObject)
	}
}

func main() {
	ascii := figlet4go.NewAsciiRender()
	renderStr, _ := ascii.Render("Socks")
	fmt.Print(renderStr)
	println("====================================")

	config := loadConfig()
	sockAddr := config.Socks.SocketPath
	port := config.Socks.Port
	addr := ":" + strconv.Itoa(port)

	// create and open websocket
	http.HandleFunc("/ws", handleWebsocket)

	go func() {
		println("broadcasting on " + addr)
		log.Fatal(http.ListenAndServe(addr, nil))
	}()

	// create and open unixsocket
	if err := os.RemoveAll(sockAddr); err != nil {
		log.Fatal(err)
	}

	l, err := net.Listen("unix", sockAddr)
	if err != nil {
		log.Fatal("listen error:", err)
	}
	defer l.Close()

	println("listening on " + sockAddr)
	for {
		conn, err := l.Accept()
		if err != nil {
			log.Fatal("accept error:", err)
		}

		go handleSystemsocket(conn)
	}
}
