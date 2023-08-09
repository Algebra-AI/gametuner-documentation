using Documenter
using DataFrames

# DocMeta.setdocmeta!(DataFrames, :DocTestSetup, :(using DataFrames); recursive=true)

# Build documentation.
# ====================

const pretty_url = true

makedocs(
    # options
    modules = [DataFrames],
    doctest = false,
    clean = true,
    sitename = "Game Tuner Documentation",
    format = Documenter.HTML(
        canonical = "./",
        assets = ["assets/favicon.ico"],
        edit_link = "main",
    ),
    pages = Any[
        "Introduction" => "index.md",
        "BI Tool" => Any[
            "Dashboards" => "man/Dashboards.md",
            "Stories" => "man/Stories.md",
            "Hub" => "man/Hub.md",
            "Annotations" => "man/Annotations.md"
        ],
        "Telemetry" => Any[
            "SDK" => "man/SDK.md",
            "Standard Events" => "man/StandardEvents.md",
            "Eventory" => "man/Eventory.md",
        ],
        "Data Platform" => Any[
            "User Entity" => "man/UserEntity.md",
            "Integrated Data Sources" => "man/IntegratedSources.md",
            "DDA (Direct Data Access)" => "man/DDA.md",
        ],
        "Semantic Layer" => "man/SemanticLayer.md",

    ],
    strict = false
)

# Deploy built documentation from Travis.
# =======================================

# deploydocs(
#     # options
#     repo = "github.com/JuliaData/DataFrames.jl.git",
#     target = "build",
#     deps = nothing,
#     make = nothing,
#     devbranch = "main"
# )

function fix_html(src_path="src", pretty_url=true)
    source_path = joinpath(pwd(), src_path)
    build_path = joinpath(pwd(), "build")

    for (root, dirs, files) in walkdir(source_path)
        for file in files
            fullpath = joinpath(root, file)
            filename, filetype  = splitext(file)
            relative_path = remove(remove(fullpath, source_path*"/"), file)

            if filetype == ".md"
                images = get_images(fullpath)
                if filename == "index"
                    htmlfile = joinpath(build_path, "index.html")
                else
                    htmlfile = joinpath(build_path, relative_path, filename, "index.html")
                end
                broken_images = get_broken_images(htmlfile)
                if length(images) != length(broken_images) exit(1) end
                s = read(htmlfile, String)
                for i in eachindex(images)
                    if pretty_url
                        images[i] = replace(images[i], "./assets" => "./../assets")
                    end
                    s = replace(s, broken_images[i] => images[i])
                end
                s = remove_excess(s)
                write(htmlfile, s)
            end
        end
    end
end

function remove_excess(s::String)
    s = remove(s, """<span class="docs-label is-hidden-touch">Edit on GitHub</span>""")

    m = match(r"""<a class="docs-edit-link" href="https://github.com/Algebra-AI/gametuner-documentation.+" title="Edit on GitHub"><span class="docs-icon fab"></span></a>""", s)
    if isnothing(m)
        println(s)
        println()
        println("""<a class="docs-edit-link" href="https://github.com/Algebra-AI/gametuner-documentation.+" title="Edit on GitHub"><span class="docs-icon fab"></span></a>""")
    end
    s = remove(s, String(m.match))

    m = match(r"""<p class="footer-message">.+">Documenter.jl</a> and the <a href="https://julialang.org/">Julia Programming Language</a>.</p>""", s)
    if isnothing(m)
        println(s)
        println()
        println("""<p class="footer-message">.+">Documenter.jl</a> and the <a href="https://julialang.org/">Julia Programming Language</a>.</p>""")
    end
    s = remove(s, String(m.match))

    m = match(r"""<p>This document was generated with .+Using Julia version 1.+</p>""", s)
    if isnothing(m)
        println(s)
        println()
        println("""<p>This document was generated with .+Using Julia version 1.+</p>""")
    end
    s = remove(s, String(m.match))
end

function get_images(file::String)
    s = read(file, String)
    images = String[]
    offset = 1
    while true
        m = match(r"(<img src|<center><img src).+(</center>|\"/>)", s, offset)
        if isnothing(m) break end
        push!(images, String(m.match))
        offset = m.offset + length(m.match)
    end
    return images
end

function get_broken_images(file::String)
    s = read(file, String)
    s = replace(s, "<p>" => "\n<p>")
    s = replace(s, "</p>" => "</p>\n")
    images = String[]
    offset = 1
    while true
        m = match(r"(<p>&lt;center&gt;&lt;img src=|<p>&lt;img src=).+&gt;</p>", s, offset)
        if isnothing(m) break end
        push!(images, String(m.match))
        offset = m.offset + length(m.match)
    end
    return images
end

function remove(s::String, pattern::String)
    replace(s, pattern => "")
end

println("Fixing broken images in HTML...")
fix_html()
println("Done!")