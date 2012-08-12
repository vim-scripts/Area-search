" Search area function 
"
" Language:              Python
" Maintener:             Gabriel AHTUNE <larchange@gmai.com>
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

def chunks(buf, start):
    i = start
    while i < len(buf):
        yield i, "\n".join(buf[i:min(len(buf), i + 11)])
        i = min(len(buf), i + 10)

def Search(*args):
    if len(args) < 1:
        try:
            keys = vim.eval("g:contextSearchArgs").split("%DELIMITER%")
        except:
            print("No query provided")
            return 0
    else:
        keys = args
        vim.command('let g:contextSearchArgs="%s"' % '%DELIMITER%'.join(args))
    
    cw = vim.current.window
    cb = vim.current.buffer
    for linenb, chunk in chunks(cb, cw.cursor[0]):
        if all(key in chunk for key in keys):
            print("%d, %d" % (linenb + 1, 1))
            cw.cursor = (min(len(cb), linenb + 10), 1)
            break
    else:
        print("No area match the query")
    
EOF

command -narg=* AreaSearch python Search(<f-args>)
map ,,n : python Search()<CR>
endif
