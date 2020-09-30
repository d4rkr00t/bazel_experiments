load("//:build/rules/genfile.bzl", "genfile")

def package_json(name, pkgName):
    """ Generates package.json from a template """

    genfile(
        name = "package_json",
        output = "package",
        extension = ".json",
        substitutions = {
            "NAME": pkgName,
            "DESCRIPTION": "desc",
            "REG_DEPENDENCIES": "{}",
            "DEV_DEPENDENCIES": "{}",
            "PEER_DEPENDENCIES": "{}",
        },
        template = Label("//:build/rules/package.json.tpl"),
    )
