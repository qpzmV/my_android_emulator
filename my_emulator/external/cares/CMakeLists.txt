cmake_minimum_required(VERSION 3.5)

include(android)
include(prebuilts)
# Make sure the standard set of windows libraries are available as targets
if(WINDOWS)
  include(emu-windows-libs)
endif()

android_add_library(TARGET cares
                    LIBNAME c-ares URL
                            "https://android.googlesource.com/platform/external/c-ares/+/refs/heads/emu-master-dev"
                    REPO "${ANDROID_QEMU2_TOP_DIR}/../cares/"
                    NOTICE "REPO/LICENSE.md"
                    LICENSE MIT
                    SRC src/lib/ares__addrinfo2hostent.c
                        src/lib/ares__addrinfo_localhost.c
                        src/lib/ares_android.c
                        src/lib/ares_cancel.c
                        src/lib/ares__close_sockets.c
                        src/lib/ares_create_query.c
                        src/lib/ares_data.c
                        src/lib/ares_destroy.c
                        src/lib/ares_expand_name.c
                        src/lib/ares_expand_string.c
                        src/lib/ares_fds.c
                        src/lib/ares_freeaddrinfo.c
                        src/lib/ares_free_hostent.c
                        src/lib/ares_free_string.c
                        src/lib/ares_getaddrinfo.c
                        src/lib/ares_getenv.c
                        src/lib/ares_gethostbyaddr.c
                        src/lib/ares_gethostbyname.c
                        src/lib/ares__get_hostent.c
                        src/lib/ares_getnameinfo.c
                        src/lib/ares_getsock.c
                        src/lib/ares_init.c
                        src/lib/ares_library_init.c
                        src/lib/ares_llist.c
                        src/lib/ares_mkquery.c
                        src/lib/ares_nowarn.c
                        src/lib/ares_options.c
                        src/lib/ares_parse_aaaa_reply.c
                        src/lib/ares_parse_a_reply.c
                        src/lib/ares_parse_caa_reply.c
                        src/lib/ares__parse_into_addrinfo.c
                        src/lib/ares_parse_mx_reply.c
                        src/lib/ares_parse_naptr_reply.c
                        src/lib/ares_parse_ns_reply.c
                        src/lib/ares_parse_ptr_reply.c
                        src/lib/ares_parse_soa_reply.c
                        src/lib/ares_parse_srv_reply.c
                        src/lib/ares_parse_txt_reply.c
                        src/lib/ares_parse_uri_reply.c
                        src/lib/ares_platform.c
                        src/lib/ares_process.c
                        src/lib/ares_query.c
                        src/lib/ares__readaddrinfo.c
                        src/lib/ares__read_line.c
                        src/lib/ares_search.c
                        src/lib/ares_send.c
                        src/lib/ares__sortaddrinfo.c
                        src/lib/ares_strcasecmp.c
                        src/lib/ares_strdup.c
                        src/lib/ares_strerror.c
                        src/lib/ares_strsplit.c
                        src/lib/ares_timeout.c
                        src/lib/ares__timeval.c
                        src/lib/ares_version.c
                        src/lib/ares_writev.c
                        src/lib/bitncmp.c
                        src/lib/inet_net_pton.c
                        src/lib/inet_ntop.c
                        src/lib/windows_port.c)

target_compile_definitions(cares
                           PUBLIC
                           -DCARES_BUILDING_LIBRARY
                           -D_GNU_SOURCE
                           -D_HAS_EXCEPTIONS=0
                           -DHAVE_CONFIG_H
                           -DCARES_STATICLIB)
target_include_directories(cares PUBLIC include
                                 PRIVATE src/lib)

android_target_compile_definitions(cares
                                   windows
                                   PRIVATE
                                   -DNOMINMAX
                                   -D_CRT_SECURE_NO_DEPRECATE
                                   -D_CRT_NONSTDC_NO_DEPRECATE
                                   -D_WIN32_WINNT=0x0601)

android_target_link_libraries(cares windows PRIVATE ws2_32::ws2_32)
android_target_include_directories(cares linux-x86_64 PRIVATE include/config_linux)
android_target_include_directories(cares linux-aarch64 PRIVATE include/config_linux)
android_target_include_directories(cares darwin-aarch64 PRIVATE include/config_darwin)
android_target_include_directories(cares darwin-x86_64 PRIVATE include/config_darwin)
android_target_include_directories(cares windows PRIVATE include/config_windows)
