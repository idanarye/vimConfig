" Vim syntax file
" Language:	MAXIMA
" Maintainer:  	Michael M. Tung <michael.tung@uv.es>,
"               Ismael Urraca Piedra <iurraca@yahoo.es>
" Last Change:	Tue Aug 30 13:05:05 CEST 2002

" First public release based on the syntax specifications in
" the 'Maxima Manual'. Maxima was initially designed by
" William F. Schelter at University of Texas, Austin, using
" previous sources of MIT's Macsyma system.

" This syntax file is still in development. Please send any
" suggestions to the maintainers. 

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

" MAXIMA keywords
syn keyword maximaKeyword		allbut

syn match   maximaSpecialSymbol         "?"

" MAXIMA functions
syn match   maximaFunction		"?round" 
syn match   maximaFunction		"?truncate" 
syn keyword maximaFunction    acesh acos acosh acot acoth acsc acsch activate addcol addrow
syn keyword maximaFunction    adjoint airy alarmclock algsys alias alloc allroots antid
syn keyword maximaFunction    antidiff append appendfile apply apply1 apply2 apply_nouns
syn keyword maximaFunction    applyb1 apropos args array arrayapply arrayinfo arraymake
syn keyword maximaFunction    asin asinh askinteger asksign assec asume asymp asympa at
syn keyword maximaFunction    atan atan2 atanh atom atrig1 atvalue augcoefmatrix backup
syn keyword maximaFunction    batcon bashindices batch batchload bern bernpoly bessel beta
syn keyword maximaFunction    bezout bffac bfloat bfloatp bfpsi bfzeta bgzeta bhzeta
syn keyword maximaFunction    bindtest binomial block bothcoef box break bug buildq burn
syn keyword maximaFunction    bzeta cabs canform canten carg cartan catch cbfac cf cfdisrep
syn keyword maximaFunction    cfexpand cgamma cgamma2 changevar charpoly check_overlaps
syn keyword maximaFunction    chr1 chr2 christof clearscreen closefile closeps coeff
syn keyword maximaFunction    coefmatrix col collapse columnvector combine comp2pui
syn keyword maximaFunction    compfile compile compile_file compile_lisp_file concat
syn keyword maximaFunction    conjugate cons constantp cont2part content continue contract
syn keyword maximaFunction    copylist copymatrix cos coshcot coth covdiff create_list csc
syn keyword maximaFunction    csch curvature dblint ddt deactivate debug debugprintmode
syn keyword maximaFunction    declare declare_translated declare_weight defcon define
syn keyword maximaFunction    define_variable defintd efmatch defrule deftaylor delete
syn keyword maximaFunction    delfile delta demo denom depends derivdegree derivlist
syn keyword maximaFunction    describe desolve determinant diagmatrix dimension direct
syn keyword maximaFunction    diskfree disolate disp dispcon dispform dispfun display
syn keyword maximaFunction    disprule dispterms distrib divide divsum dotsimp dpart
syn keyword maximaFunction    dscalar dummy echelon eigenvalues eigenvectors einstein
syn keyword maximaFunction    ele2comp ele2polynome ele2pui elem eliminate ematrix endcons
syn keyword maximaFunction    entermatrix entier equal erf errcatch error errormsg euler ev
syn keyword maximaFunction    eval evenp example exp expand expandwrt expandwrt_factored
syn keyword maximaFunction    explose express expt extrac_linear_equations ezgcd factcomb
syn keyword maximaFunction    factor factorial factorout factorsum facts fassave
syn keyword maximaFunction    fast_central_elements fast_linsolve fasttimes featurep fft
syn keyword maximaFunction    fib fibtophi file_type filedefaults filename_merge fillarray
syn keyword maximaFunction    first fix float floatdefunk floatnump flush flushd flushnd
syn keyword maximaFunction    forget fortmx fortran freeof fullmap fullmapl fullratsimp
syn keyword maximaFunction    fullratsubst funcsolve fundef funmake gamma gauss gcd
syn keyword maximaFunction    gcfactor gendiff genfact genmatrix get getchar gfactor
syn keyword maximaFunction    gfactorsum go gradef gramschmidt grind grobner_basis hach
syn keyword maximaFunction    hipow horner ic1 ident ieqn ift ilt imagpart indices infix
syn keyword maximaFunction    innerproduct inpart inrt integerp integrate interpolate
syn keyword maximaFunction    intopois intosum intsce invert is isolate isqrt jacobi kdelta
syn keyword maximaFunction    kill killcontext kostka labels laplace last lc lcm ldefint
syn keyword maximaFunction    ldisp ldisplay length let letrules letsimp lgtreillis lhs
syn keyword maximaFunction    limit linsolve lispdebugmode listarray listofvars load
syn keyword maximaFunction    loadfile local log logcontract lopow lorentz lpart lratsubst
syn keyword maximaFunction    lriccicom ltreillis m1pbranch make_array makebox makefact
syn keyword maximaFunction    makegamma makelist map mapatom maplist matchdeclare matchfix
syn keyword maximaFunction    matrix matrixmap matrixp mattrace max member metric min
syn keyword maximaFunction    minfactorial minor mod mode_declare mode_identity mon2schur
syn keyword maximaFunction    mono monomial_dimensions motion multi_elem multi_orbit
syn keyword maximaFunction    multi_pui multinomial multsym multthru nc_degree ncexpt
syn keyword maximaFunction    ncharpoly new-disrep newcontext newdet newton niceindices
syn keyword maximaFunction    nonscalarp nostring nounity nroots nterms ntermsg ntermsrci
syn keyword maximaFunction    nthroot num numberp numberval numfactor nusum nzeta oddp ode
syn keyword maximaFunction    ode2 openplot_curves optimize orbit ordergreat ordergreatp
syn keyword maximaFunction    orderless orderlessp outofpois pade part part2cont partfrac
syn keyword maximaFunction    partition partpol pcoeff permanent permut pickapart playback
syn keyword maximaFunction    plog plot2d plot2d_ps plot3d poisdiff poisexpt poisint
syn keyword maximaFunction    poismap poisplus poissimp poissubst poistimes poistrim
syn keyword maximaFunction    polarform polartorect polynome2ele potential powers
syn keyword maximaFunction    powerseries prime primep print printpois printprops prodrac
syn keyword maximaFunction    product properties propvars pscom psdraw_curve psi pui
syn keyword maximaFunction    pui_direct pui2comp pui2ele pui2polynome puireduc put qput qq
syn keyword maximaFunction    quanc8 quit qunit quotient radcan raiseriemann random rank
syn keyword maximaFunction    rat ratcoef ratdenom ratdiff ratdisrep ratexpand ratnumer
syn keyword maximaFunction    ratnump ratp ratsimp ratsubs ratvars ratweight read readonly
syn keyword maximaFunction    realpart realrules rearray rectform recttopolar rem remainder
syn keyword maximaFunction    remarray rembox remcon remfunction remlet remove remrule
syn keyword maximaFunction    remtrace remvalue rename reset residue resolvante
syn keyword maximaFunction    resolvante_alternee1 resolvante_bipartite resolvante_diedrale
syn keyword maximaFunction    resolvante_klein resolvante_klein3 resolvante_produit_sym
syn keyword maximaFunction    resolvante_unitaire resolvante_vierer rest restore resultant
syn keyword maximaFunction    return reveal reverse reverte rhs riccicom riemman rinvariant
syn keyword maximaFunction    risch rncombine romberg room rootscontract row save scalarp
syn keyword maximaFunction    scalefactors scanmap schur2comp sconcat scsimp scurvature sec
syn keyword maximaFunction    sech set_plot_option set_up_dot_simplifications setelmx setup
syn keyword maximaFunction    setup_autoload show showratvars sign signum
syn keyword maximaFunction    similaritytransform simp sin sinh solve somrac sort sprint
syn keyword maximaFunction    sqfr sqrt srrat sstatus status string stringout sublis
syn keyword maximaFunction    sublist submatrix subst substinpart substpart subvarp sum
syn keyword maximaFunction    sumcontract supcontext symbolp system tan tanh taylor
syn keyword maximaFunction    taylor_simplifier taylorinfo taylorp taytorat tcl_output
syn keyword maximaFunction    tcontract tellrat tellsimp tellsimpafter throw time timer
syn keyword maximaFunction    timer_info tldefint tlimit to_lisp tobreak todd_coxeter
syn keyword maximaFunction    toplevel totaldisrep totient tpartpol tr_warnings_get trace
syn keyword maximaFunction    trace_options transform translate translate_file transpose
syn keyword maximaFunction    treillis treinat triangularize tringexpand trigrat trigreduce
syn keyword maximaFunction    trigsimp trunc tsetup ttransform undiff uniteigenvectors
syn keyword maximaFunction    unitvector unknown unorder unsum untellrat untrace
syn keyword maximaFunction    vectorpotential vectorsimp verbify weyl writefile
syn keyword maximaFunction    xgraph_curves xthru zeroequiv zeromatrix zeta zrpoly zsolve

" MAXIMA specials
"syn match   maximaSpecial     "?.*"
syn region  maximaSpecial matchgroup=maximaSpecial start="?" matchgroup=NONE end="[A-Z]*[0-9]*"

" MAXIMA variables
syn match maximaVariable      "%" 
syn match maximaVariable      "%%"
syn match maximaVariable      "%edispflag"
syn match maximaVariable      "%rnum_list" 
syn keyword maximaVariable    absboxchar activecontexts algebraic algepsilon algexact
syn keyword maximaVariable    aliases all_dotsimp_denoms allsym arrays askexp assume_pos
syn keyword maximaVariable    asume_pos_pred assumescalar backsubst backtrace batchkill
syn keyword maximaVariable    batcount berlefact bftorat bftrunc bothcases boxchar breakup
syn keyword maximaVariable    cauchysum cflength change_filedefaults compgrind context
syn keyword maximaVariable    contexts counter current_let_rule_package cursordisp
syn keyword maximaVariable    debugmode default_let_rule_package demoivre dependecies
syn keyword maximaVariable    derivabbrev derivsubst detout diagmetric dim direc dispflag
syn keyword maximaVariable    display_format_internal display2d doallmxops domain domxexpt
syn keyword maximaVariable    domxmxops domxnctimes dontfactor doscmxops doscmxplus
syn keyword maximaVariable    dot0nscsimp dot0simp dot1simp dotassoc dotconstrules
syn keyword maximaVariable    dotdistrib dotexptsimp dotident dotscrules dskall erfflag
syn keyword maximaVariable    errexp errintsce error_size error_syms errorfun evflag evfun
syn keyword maximaVariable    expandwrt_denom expon exponentialize expop exptdispflag
syn keyword maximaVariable    exptisolate exptsubst facexpnad factlimit factorflag false
syn keyword maximaVariable    file_search file_string_print filename filenum float2bf
syn keyword maximaVariable    fortindent fortspaces fpprec fpprintprec functions gammalim
syn keyword maximaVariable    genindex gensumnum glovalsolve gradefs halfangles ibase
syn keyword maximaVariable    ieqnprint in_netmath inchar inf infinity inflag infolists
syn keyword maximaVariable    integration_constant_counter intfaclim intpolabs intpolerror
syn keyword maximaVariable    intepolrel isolate_wrt_times keepfloat lasttime
syn keyword maximaVariable    let_rule_packages letrat lhospitallim linechar linedisp linel
syn keyword maximaVariable    linenum linsolve_params linsolvewarm listarith listconstvars
syn keyword maximaVariable    listdummyvars listp lmxchar loadprint logabs logarc
syn keyword maximaVariable    logconcoeffp logexpand lognegint lognumer logsimp
syn keyword maximaVariable    macroexpansion maperror matrix_element_add
syn keyword maximaVariable    matrix_element_mult matrix_element_transpose maxapplydepth
syn keyword maximaVariable    maxapplyheight maxnegex maxposex maxprime maxtayorder minf
syn keyword maximaVariable    mode_check_errorp mode_check_warnp mode_checkp modulus
syn keyword maximaVariable    multiplicities myoptions negdistrib negsumdispflag newfac
syn keyword maximaVariable    niceindicespref nolabels noundisp obase omega opproperties
syn keyword maximaVariable    opsubst optimprefix optionset outchar packagefile parsewindow
syn keyword maximaVariable    partswitch pfeformat piece plot_options poislim powerdisp
syn keyword maximaVariable    prederror prodhack programmode prompt psexpand radexpnd
syn keyword maximaVariable    radprodexpand radsubstflag ratalgdenom ratdenomdivide
syn keyword maximaVariable    rateinstein ratepsilon ratfac ratmx ratprint ratrieman
syn keyword maximaVariable    ratriemann ratsimpexpons ratweights ratweyl ratwtlvl realonly
syn keyword maximaVariable    refcheck rmxchar rombergabs rombergit rombergmin rombergtol
syn keyword maximaVariable    rootsconmode rootsepsilon savedef savefactors scalarmatrixp
syn keyword maximaVariable    setcheck setcheckbreak setval showtime simpsum
syn keyword maximaVariable    solve_inconsistent_error solvedecomposes solveexplicit
syn keyword maximaVariable    solvefactors solvenullwarn solveradcan solvetrigwarn sparse
syn keyword maximaVariable    sqrtdispflag stardisp sublis_apply_lambda sumexpand sumhack
syn keyword maximaVariable    sumsplitfact taylor_logexpand taylor_order_coefficients
syn keyword maximaVariable    taylor_truncate_polynomials taylordepth timer_devalue
syn keyword maximaVariable    tlimswitch tr_array_as_ref tr_bound_function_applyp
syn keyword maximaVariable    tr_file_tty_messagesp tr_float_can_branch_complex
syn keyword maximaVariable    tr_function_call_default tr_gen_tags tr_numer
syn keyword maximaVariable    tr_optimize_max_loop tr_output_file_default
syn keyword maximaVariable    tr_predicate_brain_damage tr_semicompile tr_state_vars
syn keyword maximaVariable    tr_true_name_of_file_being_translated tr_version
syn keyword maximaVariable    tr_warn_bad_function_calls tr_warn_fexpr tr_warn_meval
syn keyword maximaVariable    tr_warn_mode tr_warn_undeclared tr_warn_undefined_variable
syn keyword maximaVariable    tr_windy transbind transcompile transrun trigexpandplus
syn keyword maximaVariable    trigexpandtimes triginverses trigsign true ttyintfun
syn keyword maximaVariable    ttyintnum ttyoff undeclaredwarn use_fast_arrays values
syn keyword maximaVariable    vect_cross verbose zerobern zeta%pi zunderflow
syn region  maximaVariable matchgroup=maximaVariable start="%" matchgroup=NONE end="[A-Z]*[0-9]*"


" More MAXIMA functions
syn match   maximaFunction		"%th" 


" MAXIMA declarations
syn keyword maximaDeclaration	antisymmetric alphabetic commutative feature
syn keyword maximaDeclaration	features lassociative linear mainvar multiplicative
syn keyword maximaDeclaration	nonscalar noun outative postfun rassociative
syn keyword maximaDeclaration	symmetric


" MAXIMA conditionals
syn keyword maximaConditional		if else while for go do

" MAXIMA operators
syn match   maximaOperator		"!!"
syn match   maximaOperator		"!"
syn match   maximaOperator		"#"
syn match   maximaOperator		"'"
syn match   maximaOperator		"\."
syn match   maximaOperator		"::="
syn match   maximaOperator		"::"
syn match   maximaOperator		":="
syn match   maximaOperator		":"
"syn match   maximaOperator		"=[^=]"
syn match   maximaOperator		"="
syn keyword maximaOperator		pred

" MAXIMA macros
syn match   maximaMacro			"with_stdout(.*)"
syn match   maximaMacro			"buildq"

" MAXIMA special symbol
syn keyword maximaSpecialSymbol		additive diff infeval noeval nouns numer
syn keyword maximaSpecialSymbol		poisson props verb
syn match   maximaSpecialSymbol		"\["
syn match   maximaSpecialSymbol		"\]"

" MAXIMA special operator
syn keyword   maximaSpecialOperator	constant do for if

" MAXIMA property
syn keyword   maximaProperty		atomgrad

" MAXIMA comments / strings / numbers
syn region  maximaComment matchgroup=maximaCommentStart start="/\*" matchgroup=NONE end="\*/"
syn region  maximaComment matchgroup=maximaCommentStart start=";" matchgroup=NONE end="$"

syn region  maximaString		start=+"+  end=+"+
syn match   maximaNumber		"\<\d\+\>"
syn match   maximaNumber		"\<\d\+\.\d*\>"
syn match   maximaNumber		"\.\d\+\>"
syn match   maximaNumber		"-\.\d\+\>" contains=Number
syn match   maximaNumber		"-\d\+\>" contains=Number

" floating point number, without a decimal point
"syn match maximaNumber	display "\<\d\+[de][-+]\=\d\+\(_\a\w*\)\=\>"

" floating point number, starting with a decimal point
syn match maximaNumber   display "\.\d\+\([de][-+]\=\d\+\)\=\(_\a\w*\)\=\>"

" floating point number, no digits after decimal
syn match maximaNumber   display "\<\d\+\.\([de][-+]\=\d\+\)\=\(_\a\w*\)\=\>"



" hi User Labels
syn sync ccomment maximaComment minlines=10

if !exists("did_maxima_syn_inits")
  let did_maxima_syn_inits = 1
  " The default methods for hi-ing.  Can be overridden later
  hi link maximaConditional	Conditional
  hi link maximaNumber		Number
  hi link maximaFunction	Statement
  hi link maximaOperator	Operator
  hi link maximaComment		Comment
  hi link maximaCommentStart	Comment 
  hi link maximaDeclaration	Preproc
  hi link maximaKeyword		Type
  hi link maximaString		String
  hi link maximaVariable	Identifier
  hi link maximaSpecial		Special
  hi link maximaSpecialOperator	Special
  hi link maximaProperty	Special
  hi link maximaMacro		Macro

  if !exists("maxima_enhanced_color") 
  hi link maximaSpecialSymbol	Special
  else
  " enhanced color mode
    hi link maximaSpecialSymbol PreCondit
    " dark and a light background for local types 
    if &background == "dark"
      hi SpecialSymbol term=underline ctermfg=LightGreen guifg=LightGreen gui=bold
    else
      hi SpecialSymbol term=underline ctermfg=DarkGreen guifg=SeaGreen gui=bold
    endif
    " change slightly the default for dark gvim
    if has("gui_running") && &background == "dark"
      hi Conditional guifg=LightBlue gui=bold
      hi Statement guifg=LightYellow 
    endif
  endif
endif

  let b:current_syntax = "maxima"

" vim: ts=8
