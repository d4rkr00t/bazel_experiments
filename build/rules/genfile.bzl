def _genfile_impl(ctx):
    ctx.actions.expand_template(
        template = ctx.file.template,
        output = ctx.outputs.out,
        substitutions = ctx.attr.substitutions,
    )
    return [
        DefaultInfo(files = depset([ctx.outputs.out])),
    ]

genfile = rule(
    implementation = _genfile_impl,
    attrs = {
        "template": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "extension": attr.string(default = ".json"),
        "output": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "substitutions": attr.string_dict(),
    },
    outputs = {
        "out": "%{output}%{extension}",
    },
    output_to_genfiles = True,
)
