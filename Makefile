GO = go
APXS = apxs
APR_CONFIG = apr-config
APU_CONFIG = apu-config
LIBTOOL = $(shell $(APXS) -q LIBTOOL)
HTTPD = $(shell $(APXS) -q exp_sbindir)/$(shell $(APXS) -q progname)
exp_CPPFLAGS = -I$(shell $(APXS) -q exp_includedir)
exp_LDFLAGS = -L$(shell $(APXS) -q exp_libdir)
exp_libexecdir = $(shell $(APXS) -q exp_libexecdir)
apr_CPPFLAGS = $(shell $(APR_CONFIG) --includes --cppflags)
apr_LDFLAGS = $(shell $(APR_CONFIG) --ldflags --libs)
apu_CPPFLAGS = $(shell $(APU_CONFIG) --includes)
apu_LDFLAGS = $(shell $(APU_CONFIG) --ldflags --libs)

all: mod_ymotongpoo.so

clean:
	rm -rf *.so

mod_ymotongpoo.so: mod_ymotongpoo.go module.go
	CGO_CPPFLAGS="$(apr_CPPFLAGS) $(apu_CPPFLAGS) $(exp_CPPFLAGS) $(CPPFLAGS)" \
	CGO_LDFLAGS="$(apr_LDFLAGS) $(apu_LDFLAGS) $(exp_LDFLAGS) $(LDFLAGS) -Wl,--unresolved-symbols=ignore-all" \
	$(GO) build -buildmode=c-shared -o mod_ymotongpoo.so

.PHONY: all
