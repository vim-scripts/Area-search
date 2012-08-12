" Search area function 
"
" Language:              Python
" Maintener:             Gabriel AHTUNE <larchange@gmail.com>
" Latest Revision:       2012-08-12
"
" This script enable you to type:
" 
"    >>> :AreaSearch hello math world
"
" in order to find an area of the current document (after your cursor) that
" contains the words hello math and world in any order
"
" on pressing ,,n the cursor go to the next area matching the query
"
" This script need the plugin python installed
" To install it, just drop it in ~/.vim/plugin
"

if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

if has('python')

python << EOF
# -*- encoding: utf-8 -*-
import vim

def chunks(buf, start, nbline=10):
    i = start
    while i < len(buf):
        yield i, "\n".join(buf[i:min(len(buf), i + nbline + 1)])
        i = min(len(buf), i + 1)

def Search(*args):
    cw = vim.current.window
    cb = vim.current.buffer
    if len(args) < 1:
        try:
            keys = vim.eval("g:contextSearchArgs").split("%DELIMITER%")
        except:
            print("No query provided")
            return 0
    else:
        keys = args
        vim.command('let g:contextSearchArgs="%s"' % '%DELIMITER%'.join(args))
    
    for linenb, chunk in chunks(cb, cw.cursor[0] + 1):
        if all(key in chunk for key in keys):
            print("%d, %d" % (linenb + 10, 1))
            cw.cursor = (min(len(cb), linenb + 11), 1)
            for key in keys:
                vim.command('let m=matchadd("Search", "%s")' % key)
            break
    else:
        print("No area match the query")
    
EOF

command -narg=* AreaSearch python Search(<f-args>)
map ,,n : python Search()<CR>
endif
