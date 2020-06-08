{smcl}
{* *! version 1.0  6 Jun 2020}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "C:\ado\plus\p\plot_poly##syntax"}{...}
{viewerjumpto "Description" "C:\ado\plus\p\plot_poly##description"}{...}
{viewerjumpto "Options" "C:\ado\plus\p\plot_poly##options"}{...}
{viewerjumpto "Remarks" "C:\ado\plus\p\plot_poly##remarks"}{...}
{viewerjumpto "Examples" "C:\ado\plus\p\plot_poly##examples"}{...}
{title:Title}
{phang}
{bf:plot_poly} {hline 2} a command to plot polynomial dose-responses

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:plot_poly}
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required }
{synopt:{opt pre:fix(string)}} prefix used to identify the X variable pattern. Must follow the pattern {it:varn1 varn2 varn3}... {p_end}
{synopt:{opt o:rderpoly(#)}} polynomial order {p_end}
{synopt:{opt om:it(#)}} reference point for the dose response {p_end}
{syntab:Optional}
{synopt:{opt mi:n_s(#)}}  specifies the minimum value to use for the dose-reponse plot
{p_end}
{synopt:{opt ma:x_s(#)}}  specifies the maximum value to use for the dose-reponse plot
{p_end}
{synopt:{opt smooth}}  predict dose response for any range, even outside data support
{p_end}
{synopt:{opt step(#)}}   specifies the granularity of x variable when smooth is specified
{p_end}
{synopt:{opt hist}}  adds histogram of the data support
{p_end}
{synopt:{opt plotcommand(string)}}  option to add any classic graph option
{p_end}
{synopt:{opt sav:e_data(string)}} saves data used for the graph at the specified location {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}
{pstd}

{pstd}
 {cmd:plot_poly} generates a graph for polynomial dose-response after linear regression for any polynomial order. Option to add histogram of underlying data support.

{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt mi:n_s(#)}     specifies the minimum value to use for the dose-reponse plot, default is the minimum value insample.

{pstd}
{p_end}
{phang}
{opt ma:x_s(#)}     specifies the maximum value to use for the dose-reponse plot, default is the maximum value insample.

{pstd}
{p_end}
{phang}
{opt smooth}     predict dose response for any range, even outside data support.

{pstd}
{p_end}
{phang}
{opt step(#)}   specifies the granularity of x variable when smooth is specified, default value is 1. can only be between 0 and 1.

{pstd}
{p_end}
{phang}
{opt hist}     adds histogram of the underlying data

{pstd}
{p_end}
{phang}
{opt plotcommand(string)}     option to add any classic graph option

{pstd}
{p_end}

{marker examples}{...}
{title:Examples}
{pstd}
sysuse auto, clear 
{p_end}
{pstd}
rename mpg mpg1
{p_end}
{pstd}
 g mpg2 = mpg1^2
{p_end}
{pstd}
 g mpg3 = mpg1^3
{p_end}
{pstd}
reg price mpg1 mpg2 mpg3
{p_end}
{pstd}
sum mpg1
{p_end}
{pstd}
local avg = r(mean)
{p_end}
{pstd}
plot_poly, prefix(mpg) orderpoly(3) omit() hist smooth

{title:Author}
{p}

Sébastien Annan-Phan, University of California, Berkeley.

Email {browse "mailto:sphan@berkeley.edu":sphan@berkeley.edu}


