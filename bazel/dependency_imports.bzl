load("@rules_foreign_cc//:workspace_definitions.bzl", "rules_foreign_cc_dependencies")
load("@com_google_googleapis//:repository_rules.bzl", "switched_rules_by_language")
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load(":udpa_http_archive.bzl", "udpa_http_archive")

# go version for rules_go
GO_VERSION = "1.12.8"

def udpa_dependency_imports(go_version = GO_VERSION):
    rules_foreign_cc_dependencies()
    go_rules_dependencies()
    go_register_toolchains(go_version)
    gazelle_dependencies()

    switched_rules_by_language(
        name = "com_google_googleapis_imports",
        cc = True,
        go = True,
        grpc = True,
        rules_override = {
            "py_proto_library": "@com_github_cncf_udpa//bazel:api_build_system.bzl",
        },
    )

    # golang repos
    udpa_http_archive(
        name = "org_golang_google_grpc",
        locations = GO_REPOSITORY_LOCATIONS,
        golang_repo = True,
        build_file_proto_mode = "disable",
    )

    udpa_http_archive(
        name = "org_golang_x_net",
        golang_repo = True,
        locations = GO_REPOSITORY_LOCATIONS,
    )

    udpa_http_archive(
        name = "org_golang_x_text",
        golang_repo = True,
        locations = GO_REPOSITORY_LOCATIONS,
    )
