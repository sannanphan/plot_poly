program plot_poly
version 14
syntax , PREfix(string) Orderpoly(real) OMit(real) [MIn_s(real 123456789) MAx_s(real 123456789) smooth step(real 1) hist plotcommand(string) SAVe_data(string)]


/* ====================================================
S. ANNAN-PHAN
SPHAN@BERKELEY>EDU
6/2020
==================================================== */

/* START HELP FILE
title[a command to plot polynomial dose-responses]

desc[
 {cmd:plot_poly} generates a graph for polynomial dose-response after linear regression for any polynomial order. Option to add histogram of underlying data support.
]
opt[min_s(#) specifies the minimum value to use for the dose-reponse plot]
opt[max_s(#) specifies the maximum value to use for the dose-reponse plot]
opt[smooth() predict dose response for any range, even outside data support]
opt[step(#)  specifies the granularity of x variable when smooth is specified]
opt[SAVe_data saves the data used for the graph at the specified location]
opt[hist adds histogram of the data support]
opt[plotcommand option to add any classic graph option]



example[sysuse auto, clear 

 rename mpg mpg1
 
 g mpg2 = mpg1^2
 
 g mpg3 = mpg1^3
 
 reg price mpg1 mpg2 mpg3
 
 sum mpg1
 
 local avg = r(mean)
 
 plot_poly, prefix(mpg) orderpoly(3) omit(`avg') hist smooth]
author[Sébastien Annan-Phan]
institute[University of California, Berkeley]
email[sphan@berkeley.edu]

END HELP FILE */


if `step' > 1 | `step' < 0{
	di as err "step should be between 0 and 1"
	exit
}
local hist_scale = 0.5 * `step'
quietly{
sum `prefix'1 if e(sample)
if `min_s' == 123456789 {
	local min_s = floor(r(min))
}
if `max_s' == 123456789 {
	local max_s = ceil(r(max))
}

local line = "_b[`prefix'1] * (`prefix'1 - `omit')"
foreach k of num 2/`orderpoly' {
	local add = "+ _b[`prefix'`k'] * (`prefix'`k' - `omit'^`k')"
	local line "`line' `add'"
}


if "`smooth'" == "smooth" {

	preserve
		tempvar BIN total
		g `BIN' = round(`prefix'1,`step')
		g counter = 1
		collapse (sum) counter, by(`BIN')
		egen `total' = sum(counter)
		replace counter = counter / `total'
		rename `BIN' `prefix'1
		tempfile histo 
		save `histo'		
	restore


	local obs = (`max_s' - `min_s')/`step' + 1
	preserve
		drop if _n > 0
		set obs `obs'
		replace `prefix'1 = _n*`step' + `min_s' - 1*`step'
		foreach k of num 2/`orderpoly' {
			replace `prefix'`k' = `prefix'1 ^ `k'	
		}
		predictnl yhat = `line', se(se) ci(lowerci upperci)
		sort `prefix'1
		
		
		if "`hist'" == "hist" {
		merge 1:1 `prefix'1 using `histo'
		sort `prefix'1		
		tw (bar counter `prefix'1, barw(`step') yaxis(2) lc(white%80) fc(navy%80)) ///
		(rarea upper lower `prefix'1, col(ebblue*.15%80) fi(100)) ///
		(line yhat `prefix'1, lc(maroon) yline(0,lc(black) lp(dash)) ///
		ytitle("Marginal Impact") legend(off) `plotcommand' yscale(alt) ///
		yscale(alt lstyle(none) axis(2)) ylabel(0 `hist_scale', axis(2) noticks nolabels) ///
		ytitle("", axis(2)))
		
		}
		else {
			tw (rarea upper lower `prefix'1, col(ebblue*.15)) ///
			(line yhat `prefix'1, lc(maroon) yline(0,lc(black) lp(dash)) ///
			ytitle("Marginal Impact") legend(off) `plotcommand')
		}
		*keep `prefix'1 yhat upp low
		rename `prefix'1 x
		if "`save_data'" != "" {
			preserve
			keep x yhat se lowerci upperci
			save `save_data', replace
			restore
		}
	restore
}
else{
	sort `prefix'1
	tempvar yhat lowerci upperci
	predictnl `yhat' = `line', ci(`lowerci' `upperci')	
	if "`hist'" == "hist" {
		tw (hist `prefix'1, gap(10) yaxis(2) lc(navy%80) fc(navy%80)) ///
		(rspike `upperci' `lowerci' `prefix'1, col(maroon*.15)) ///
		(scatter `yhat' `prefix'1, mc(maroon%50) msize(vsmall)  ///
		yline(0,lc(black) lp(dash)) ytitle("Marginal Impact") ///
		legend(off) `plotcommand' yscale(alt) yscale(alt lstyle(none) axis(2)) ///
		ylabel(0(0.5)0.5, axis(2) noticks nolabels) ytitle("", axis(2)))
	}
	else {
		tw (rspike `upperci' `lowerci' `prefix'1, col(maroon*.15)) ///
		(scatter `yhat' `prefix'1, mc(maroon%50) msize(vsmall)  ///
		yline(0,lc(black) lp(dash)) ytitle("Marginal Impact") ///
		legend(off) `plotcommand')	
	}
}
}


end

