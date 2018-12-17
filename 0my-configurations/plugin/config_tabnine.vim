let g:tabnine_executablePath = '/home/idanarye/TabNine/binaries/1.0.10/x86_64-unknown-linux-gnu/TabNine'

inoremap <C-x><C-\> <C-r>=myutil#invokeCompletion(function('tabnine#complete'))<Cr>
