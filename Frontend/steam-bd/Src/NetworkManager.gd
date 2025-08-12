extends Node

var request_queue = []
const maximo := 3
var active_requests = 0

func make_request(url: String, callback: Callable,method: int = HTTPClient.METHOD_GET,headers: Array = [],body: String = ""):
	request_queue.append({
		"url": url,
		"callback": callback,
		"method": method,
		"headers": headers,
		"body": body
	})
	_process_queue()


func _process_queue():
	if active_requests < maximo and request_queue.size() > 0:
		var req_data = request_queue.pop_front()
		var http = HTTPRequest.new()
		add_child(http)
		active_requests += 1
		http.request_completed.connect(func(result, response_code, headers, body):
			req_data.callback.call(result, response_code, headers, body)
			http.queue_free()
			active_requests -= 1
			_process_queue()
		)
		http.request(
			req_data.url,
			req_data.headers,
			req_data.method,
			req_data.body
		)
