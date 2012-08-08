" Vim syntax file
" Language:		ASP.NET (C#)
" Maintainer:		Rob Hoelz <hoelz@wisc.edu>
" Info:			$Id: aspnetcs.vim,v 1.0 2007/1/11
" __________________________________________________________

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

if !exists("main_syntax")
    let main_syntax = 'cs'
endif

if version < 600
    so <sfile>:p:h/html.vim
    syn include @AspNetCSharpScript <sfile>:p:h/cs.vim
else
    runtime! syntax/html.vim
    unlet b:current_syntax
    syn include @AspNetCSharpScript syntax/cs.vim
endif

syn cluster htmlPreproc add=AspNetCSharpInsideHtmlTags

syn case ignore

" Directives
syn keyword AspNetDirective Assembly Control Implements Import Master MasterType OutputCache Page PreviousPageType Reference Register Application contained

" Directive Attributes
syn keyword AspNetAttribute AspCompat Async AsyncTimeOut AutoEventWireup Buffer CacheProfile ClassName ClientTarget CodeBehind CodeFile CodeFileBaseClass CodeFileBehindClass CodePage CompilationMode CompilerOptions ContentType Culture Debug Description Duration EnableEventValidation EnableSessionState EnableTheming EnableViewState EnableViewStateMac ErrorPage Explicit Inherits LCID Language LinePragmas Location MaintainScrollPositionOnPostback MasterPageFile Name NoStore ResponseEncoding Shared SmartNavigation SqlDependency Src Strict StyleSheetTheme TargetSchema Theme Title Trace TraceMode Transaction TypeName UICulture ValidateRequest VaryByControl VaryByCustom VaryByHeader VaryByParam ViewStateEncryptionMode VirtualPath WarningLevel Interface Namespace Src Tagname Tagprefix VirtualPath contained

" Directive Strings
syn region AspNetDirectiveString matchgroup=String start=+"+ end=+"+ contained
syn region AspNetDirectiveString matchgroup=String start=+'+ end=+'+ contained

" <% ... %> highlighting
syn region AspNetCSharpInsideHtmlTags keepend matchgroup=Delimiter start=+<%=\=+ skip=+".*%>.*"+ end=+%>+ contains=@AspNetCSharpScript
" <script language="C#">...</script> highlighting
syn region AspNetCSharpInsideHtmlTags keepend matchgroup=Delimiter start=+<script\s\+language="\=C#"\=[^>]*>+ end=+</script>+ contains=@AspNetCSharpScript
" ASP.NET directive highlighting
syn region AspNetDirectiveContainer keepend start=+<%@+ skip=+".*%>.*"+ end=+%>+ contains=AspNetDirective,AspNetAttribute,AspNetDirectiveString

hi AspNetDirective ctermfg=green guifg=green
hi AspNetAttribute ctermfg=cyan guifg=cyan
hi AspNetDirectiveContainer ctermfg=yellow guifg=yellow
hi AspNetDirectiveString ctermfg=magenta guifg=magenta

let b:current_syntax = "aspnetcs"
