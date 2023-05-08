require'blunder'.setup {
    formats = {
        cargo = "%f:%l:%c: %t%*[^:]: %m,%f:%l:%c: %*\\d:%*\\d %t%*[^:]: %m,%-G%f:%l %s,%-G%*[ ]^,%-G%*[ ]^%*[~],%-G%*[ ]...,%-G,%-Gerror: aborting %.%#,%-Gerror: Could not compile %.%#,%Eerror: %m,%Eerror[E%n]: %m,%Wwarning: %m,%Inote: %m,%C %#--> %f:%l:%c,%-G%\\s%#Downloading%.%#,%-G%\\s%#Compiling%.%#,%-G%\\s%#Finished%.%#,%-G%\\s%#error: Could not compile %.%#,%-G%\\s%#To learn more\\,%.%#",
        csc = "%#%f(%l\\,%c): %m",
        dmd = "%f(%l): %m",
        dub = "%f(%l): %m,%f(%l\\,%c): %m",
        eclim_project_build = "%t:%f:%l:%c:%m",
        gradle = "%t: file://%f:%l:%c %m,%A%f:%l:%m,%-Z%p^,%-C%.%#,%t: %f: (%l\\, %c): %m",
        javac = "%A%f:%l:%m,%-Z%p^,%-C%.%#",
        ldc = "%f(%l): %m",
        ldc2 = "%f(%l): %m",
        mcs = "%f(%l\\,%c): %m",
        rdmd = "%f(%l): %m",
        ruby = "%f:%l:%m",
        rustc = "%f:%l:%c: %t%*[^:]: %m,%f:%l:%c: %*\\d:%*\\d %t%*[^:]: %m,%-G%f:%l %s,%-G%*[ ]^,%-G%*[ ]^%*[~],%-G%*[ ]...,%-G,%-Gerror: aborting %.%#,%-Gerror: Could not compile %.%#,%Eerror: %m,%Eerror[E%n]: %m,%Wwarning: %m,%Inote: %m,%C %#--> %f:%l:%c",
    }
}
