package main

//#include "httpd.h"
//#include "http_config.h"
//#include "http_core.h"
//#include "http_log.h"
//#include "http_main.h"
//#include "http_protocol.h"
//#include "http_request.h"
//#include "util_script.h"
//#include "http_connection.h"
//
//#include "apr_strings.h"
//
//extern int handler(request_rec *);
import "C"
import "unsafe"

var html = `<html>
<head>
<link href="https://fonts.googleapis.com/css?family=Chango|Pacifico" rel="stylesheet" />
<style type="text/css">
body { font-family: 'Pacifico', cursive; }
h1 { font-size: 10em; }
</style>
</head>
<body>
<h1>Happy Wedding!</h1>
</body>
</html>`

//export handler
func handler(r *C.request_rec) C.int {
	{
		str := C.CString("test/html; charset=UTF-8")
		defer C.free(unsafe.Pointer(str))
		C.ap_set_content_type(r, str)
	}
	{
		str := C.CString(html)
		defer C.free(unsafe.Pointer(str))
		C.ap_rwrite(unsafe.Pointer(str), C.int(len(html)), r)
	}
	return C.OK
}

//export registerHooks
func registerHooks(p *C.apr_pool_t) {
	C.ap_hook_handler((*C.ap_HOOK_handler_t)(C.handler), nil, nil, C.APR_HOOK_MIDDLE)
}
