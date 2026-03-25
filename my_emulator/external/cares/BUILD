cc_library(
    name = "ares",
    srcs = glob([
        "src/lib/*.c",
    ]),
    hdrs = glob([
        "include/*.h",
        "src/lib/*.h",
    ]) + select({
        "@platforms//os:linux": ["include/config_linux/ares_config.h"],
        "@platforms//os:windows": ["include/config_windows/ares_config.h"],
        "@platforms//os:macos": ["include/config_darwin/ares_config.h"],
    }),
    defines = [
        "CARES_STATICLIB",
        "CARES_BUILDING_LIBRARY",
        "HAVE_CONFIG_H",
    ] + select({
        "@platforms//os:windows": [
            "NOMINMAX",
        ],
        "//conditions:default": [],
    }),
    includes = [
        "include",
        "src/lib",
    ] + select({
        "@platforms//os:linux": ["include/config_linux"],
        "@platforms//os:windows": ["include/config_windows"],
        "@platforms//os:macos": ["include/config_darwin"],
    }),
    linkopts = select({
        "@platforms//os:windows": ["-defaultlib:ws2_32.lib"],
        "//conditions:default": [],
    }),
    linkstatic = 1,
    local_defines = [
        "_GNU_SOURCE",
        "_HAS_EXCEPTIONS=0",
    ] + select({
        "@platforms//os:windows": [
            "_CRT_NONSTDC_NO_DEPRECATE",
            "_CRT_SECURE_NO_DEPRECATE",
            "_WIN32_WINNT=0x0601",
        ],
        "//conditions:default": [],
    }),
    visibility = [
        "//visibility:public",
    ],
    alwayslink = 1,
)

cc_library(
    name = "gmock",
    srcs = ["test/gmock-1.11.0/gmock-gtest-all.cc"],
    hdrs = [
        "test/gmock-1.11.0/gmock/gmock.h",
        "test/gmock-1.11.0/gtest/gtest.h",
    ],
    includes = ["test/gmock-1.11.0"],
)

cc_test(
    name = "ares_test",
    size = "medium",
    srcs = [
        "test/ares-test.cc",
        "test/ares-test.h",
        "test/ares-test-ai.h",
        "test/ares-test-init.cc",
        "test/ares-test-internal.cc",
        "test/ares-test-main.cc",
        "test/ares-test-misc.cc",
        "test/ares-test-mock.cc",
        "test/ares-test-mock-ai.cc",
        "test/ares-test-ns.cc",
        "test/ares-test-parse.cc",
        "test/ares-test-parse-a.cc",
        "test/ares-test-parse-aaaa.cc",
        "test/ares-test-parse-caa.cc",
        "test/ares-test-parse-mx.cc",
        "test/ares-test-parse-naptr.cc",
        "test/ares-test-parse-ns.cc",
        "test/ares-test-parse-ptr.cc",
        "test/ares-test-parse-soa.cc",
        "test/ares-test-parse-soa-any.cc",
        "test/ares-test-parse-srv.cc",
        "test/ares-test-parse-txt.cc",
        "test/ares-test-parse-uri.cc",
        "test/dns-proto.cc",
        "test/dns-proto.h",
        "test/dns-proto-test.cc",
    ] + select({
        "@platforms//os:linux": ["include/config_linux/config.h"],
        "//conditions:default": [],
    }),
    deps = [
        ":ares",
        ":gmock",
    ],
)
