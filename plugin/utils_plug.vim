if exists('g:loaded_utils_plug') | finish | endif

let s:save_cpo = &cpo 
set cpo&vim 

" command to run our plugin
command! UtilsDebugProfile lua require("utils_plug.debugging").generateDebugProfile() 

let &cpo = s:save_cpo 
unlet s:save_cpo
let g:loaded_utils_plug = 1
