/* header */
version 14.2

set more off, permanently
set scheme s2mono


/* figure 1 english */
use "data_1.dta", clear

preserve
   gen d1000 = 0
      replace d1000 = 1 if units >= 1000

   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 0
      scalar lambdat0_0 = _b[/lambda0]
      scalar lambdat0_1 = _b[/lambda1]
      scalar kt0_0 = _b[/k0]
      scalar kt0_1 = _b[/k1]

   nl (justice = 1 - exp(-(({lambda0} + {lambda1 = 0} * d1000) * units)^({k0 = 1} + {k1 = 0} * d1000))) if treatment == 1
      scalar lambdat1_0 = _b[/lambda0]
      scalar lambdat1_1 = _b[/lambda1]
      scalar kt1_0 = _b[/k0]
      scalar kt1_1 = _b[/k1]

   collapse (mean) meanjustice = justice (sd) sdjustice = justice (count) n = justice, by(treatment units)

   generate ci_high = meanjustice + invttail(n - 1,0.05) * (sdjustice / sqrt(n))
   generate ci_low  = meanjustice - invttail(n - 1,0.05) * (sdjustice / sqrt(n))

   twoway (function y = 1 - exp(-((lambdat0_0) * x)^(kt0_0)), range(0 1000) lcolor(black) lpattern(solid)) ///
          (function y = 1 - exp(-((lambdat0_0 + lambdat0_1) * x)^(kt0_0 + kt0_1)), range(1000 2000) lcolor(black) lpattern(solid)) ///
          (function y = 1 - exp(-((lambdat1_0) * x)^(kt1_0)), range(0 1000) lcolor(gs8) lpattern(dash)) ///
          (function y = 1 - exp(-((lambdat1_0 + lambdat1_1) * x)^(kt1_0 + kt1_1)), range(1000 2000) lcolor(gs8) lpattern(dash)) ///
          (scatter meanjustice units if treatment == 0, mcolor(black) msize(medium) msymbol(diamond)) ///
          (rcap ci_high ci_low units if treatment == 0, lcolor(black)) ///
          (scatter meanjustice units if treatment == 1, mcolor(gs8) msize(medium) msymbol(square)) ///
          (rcap ci_high ci_low units if treatment == 1, lcolor(gs8)), ///
          title("") ///
          xtitle("Living Space") ///
          xlabel(0 "0" 500 "500" 1000 "1000" 1500 "1500" 2000 "2000", angle(forty_five)) ///
          xline(1000, lcolor(gs10) lpattern(dash)) ///
          ytitle("Evaluation") ///
          ylabel(0 "0" 0.2 "0.2" 0.4 "0.4" 0.6 "0.6" 0.8 "0.8" 1 "1", angle(horizontal)) ///
          text(0.95 1000 "Need Threshold", place(l)) ///
          legend(pos(5) ring(0) col(1) order(1 3) label(1 "Need Group") label(3 "Control Group")) ///
          graphregion(color(white)) ///
          saving(figure_1_english, replace)
   graph export "figure_1_english.pdf", as(pdf) replace
restore


/* figure 2 english */
preserve
   drop if units == 2000

   collapse (mean) meanjustice = relative_justice (sd) sdjustice = relative_justice (count) n = relative_justice, by(treatment units)

   generate ci_high = meanjustice + invttail(n - 1, 0.05) * (sdjustice / sqrt(n))
   generate ci_low  = meanjustice - invttail(n - 1, 0.05) * (sdjustice / sqrt(n))

   twoway (rcap ci_high ci_low units if treatment == 0, lcolor(black)) ///
          (rcap ci_high ci_low units if treatment == 1, lcolor(gs10)) ///
          (connected meanjustice units if treatment == 0, lcolor(black) lpattern(solid) mcolor(black) msize(medium) msymbol(diamond)) ///
          (connected meanjustice units if treatment == 1, lcolor(gs10) lpattern(dash) mcolor(gs10) msize(medium) msymbol(square)), ///
          title("") ///
          xtitle("Living Space") ///
          xlabel(0 "0, 200" 200 "200, 400" 400 "400, 600" 600 "600, 800" 800 "800, 1000" 1000 "1000, 1200" 1200 "1200, 1400" 1400 "1400, 1600" 1600 "1600, 1800" 1800 "1800, 2000", angle(forty_five)) ///
          xline(800, lcolor(gs10) lpattern(dash)) ///
          ytitle("Evaluation") ///
          ylabel(0 (1) 8, angle(horizontal)) ///
          text(0.5 800 "Need Threshold", place(l)) ///
          legend(pos(5) ring(0) col(1) order(3 4) label(3 "Need Group") label(4 "Control Group")) ///
          graphregion(color(white)) ///
          saving(figure_2_english, replace)
   graph export "figure_2_english.pdf", as(pdf) replace
restore


/* figure 3 english */
gen justice_type_finegrained = .
   replace justice_type_finegrained = 1 if ///
      subject ==   2 | ///
      subject ==  14 | ///
      subject ==  15 | ///
      subject ==  19 | ///
      subject ==  26 | ///
      subject ==  36 | ///
      subject ==  37 | ///
      subject ==  42 | ///
      subject ==  62 | ///
      subject ==  80	  
   replace justice_type_finegrained = 2 if ///
      subject ==  20 | ///
      subject ==  27 | ///
      subject ==  28 | ///
      subject ==  41 | ///
      subject ==  57 | ///
      subject ==  65 | ///
      subject ==  75 | ///
      subject ==  89 | ///
      subject ==  94
   replace justice_type_finegrained = 3 if ///
      subject ==   1 | ///
      subject ==  17 | ///
      subject ==  32 | ///
      subject ==  40 | ///
      subject ==  44 | ///
      subject ==  47 | ///
      subject ==  51 | ///
      subject ==  64	  
   replace justice_type_finegrained = 4 if ///
      subject ==   3 | ///
      subject ==   5 | ///
      subject ==  10 | ///
      subject ==  11 | ///
      subject ==  12 | ///
      subject ==  13 | ///
      subject ==  23 | ///
      subject ==  25 | ///
      subject ==  29 | ///
      subject ==  30 | ///
      subject ==  31 | ///
      subject ==  35 | ///
      subject ==  45 | ///
      subject ==  48 | ///
      subject ==  50 | ///
      subject ==  55 | ///
      subject ==  63 | ///
      subject ==  71 | ///
      subject ==  72 | ///
      subject == 102
   replace justice_type_finegrained = 5 if ///
      subject ==   4 | ///
      subject ==   6 | ///
      subject ==   7 | ///
      subject ==   8 | ///
      subject ==   9 | ///
      subject ==  16 | ///
      subject ==  18 | ///
      subject ==  21 | ///
      subject ==  22 | ///
      subject ==  24 | ///
      subject ==  34 | ///
      subject ==  38 | ///
      subject ==  39 | ///
      subject ==  43 | ///
      subject ==  46 | ///
      subject ==  49 | ///
      subject ==  52 | ///
      subject ==  53 | ///
      subject ==  54 | ///
      subject ==  58 | ///
      subject ==  59 | ///
      subject ==  60 | ///
      subject ==  61 | ///
      subject ==  66 | ///
      subject ==  67 | ///
      subject ==  68 | ///
      subject ==  69 | ///
      subject ==  73 | ///
      subject ==  76 | ///
      subject ==  77 | ///
      subject ==  79 | ///
      subject ==  81 | ///
      subject ==  82 | ///
      subject ==  83 | ///
      subject ==  84 | ///
      subject ==  85 | ///
      subject ==  87 | ///
      subject ==  88 | ///
      subject ==  90 | ///
      subject ==  91 | ///
      subject ==  92 | ///
      subject ==  93 | ///
      subject ==  95 | ///
      subject ==  97 | ///
      subject ==  98 | ///
      subject ==  99 | ///
      subject == 100 | ///
      subject == 101 | ///
      subject == 104 | ///
      subject == 105 | ///
      subject == 106 | ///
      subject == 107 | ///
      subject == 108
   replace justice_type_finegrained = 6 if ///
      subject ==  33 | ///
      subject ==  56 | ///
      subject ==  70 | ///
      subject ==  74 | ///
      subject ==  78 | ///
      subject ==  86 | ///
      subject ==  96 | ///
      subject == 103 | ///
      subject == 109

label variable justice_type_finegrained "Type"

label define justice_type_finegrained_lb 1 "Hump" 2 "Binary" 3 "Flat Above" 4 "Zero Below" 5 "Increasing" 6 "Other"
   label values justice_type_finegrained justice_type_finegrained_lb

preserve
   collapse (first) justice_type_finegrained treatment, by(subject)
   
   tabulate justice_type_finegrained treatment, cell
restore

preserve
   keep if treatment == 0

   twoway (connected justice units, mcolor(black) lpattern(solid)), ///
      by(justice_type_finegrained subject, note("") graphregion(color(white)) cols(7)) ///
      xtitle("Living Space") ///
      xlabel(0 "0" 500 "500" 1000 "1000" 1500 "1500" 2000 "2000", labsize(huge) angle(forty_five)) ///
      xline(1000, lcolor(gs10) lpattern(s)) ///
      ytitle("Evaluation") ///
      ylabel(0 "0" 0.5 "0.5" 1 "1", labsize(huge) angle(horizontal)) ///
      saving(figure_3_english, replace)
   graph export "figure_3_english.pdf", as(pdf) replace
restore


/* figure 4 english */
preserve
   keep if treatment == 1

   twoway (connected justice units, mcolor(black) lpattern(solid)), ///
      by(justice_type_finegrained subject, note("") graphregion(color(white)) cols(7)) ///
      xtitle("Living Space") ///
      xlabel(0 "0" 500 "500" 1000 "1000" 1500 "1500" 2000 "2000", labsize(huge) angle(forty_five)) ///
      xline(1000, lcolor(gs10) lpattern(s)) ///
      ytitle("Evaluation") ///
      ylabel(0 "0" 0.5 "0.5" 1 "1", labsize(huge) angle(horizontal)) ///
      saving(figure_4_english, replace)
   graph export "figure_4_english.pdf", as(pdf) replace
restore


/* figure 5 english */
use "data_2.dta", clear

preserve
   label define scenario_english_lb 0 "Need Scenario" 1 "Productivity Scenario"
      label values scenario scenario_english_lb

   la var case "Case"
   la var scenario "Scenario"
   la var productivity_a "Person A’s Productivity"
   la var productivity_b "Person B’s Productivity"
   la var need_a "Person A’s Need"
   la var need_b "Person B’s Need"
   la var equal_split "Equal Distribution"

   line need_a need_b productivity_a productivity_b equal_split case, ///
      by(scenario, note("") graphregion(fcolor(white))) ///
      ytitle("Logs") ///
      ylabel(0 "0" 500 "500" 1000 "1000" 1500 "1500" 2000 "2000", angle(horizontal)) ///
      saving(figure_5_english, replace)
   graph export "figure_5_english.pdf", as(pdf) replace
restore


/* figure 6 english */
use "data_3.dta", clear

preserve
   rename accountability_need judgment0
   rename accountability_productivity judgment1

   reshape long judgment, i(subject) j(frame)

   collapse (mean) meanj = judgment (sd) sdj = judgment (count) n = judgment, by(frame treatment)

   generate ci_high = meanj + invttail(n / 2 - 1, 0.05) * (sdj / sqrt(n / 2))
   generate ci_low  = meanj - invttail(n / 2 - 1, 0.05) * (sdj / sqrt(n / 2))

   generate tnr= .
      replace tnr = 0    if frame == 0 & treatment == 0
      replace tnr = 1    if frame == 0 & treatment == 1
      replace tnr = 2.25 if frame == 1 & treatment == 0
      replace tnr = 3.25 if frame == 1 & treatment == 1

   local pposition = 6.5
   local pposition1 = `pposition' - 0.5
   local ylim = `pposition' + 0.25

   twoway (bar meanj tnr if treatment == 0, fcolor(gs10) lcolor(black) lwidth(medium) barwidth(0.9)) ///
          (bar meanj tnr if treatment == 1, fcolor(white) lcolor(black) lwidth(medium) barwidth(0.9)) ///
          (rcap ci_high ci_low tnr, lcolor(black)) ///
          (pci `pposition1' 0    `pposition' 0, lcolor(black)) ///
          (pci `pposition'  0    `pposition' 0.2, lcolor(black)) ///
          (pci `pposition1' 1    `pposition' 1, lcolor(black)) ///
          (pci `pposition'  1    `pposition' 0.8, lcolor(black)) ///
          (pci `pposition1' 2.25 `pposition' 2.25, lcolor(black)) ///
          (pci `pposition'  2.25 `pposition' 2.45, lcolor(black)) ///
          (pci `pposition1' 3.25 `pposition' 3.25, lcolor(black)) ///
          (pci `pposition'  3.25 `pposition' 3.05, lcolor(black)), ///
          title("") ///
          xtitle("Scenario and Group") ///
          xlabel(0 `""Need," "Low" "Account.""' 1 `""Need," "High" "Account.""' 2.25 `""Productivity," "Low" "Account.""' 3.25 `""Productivity," "High" "Account.""') ///
          ytitle("Evaluation") ///
          yscale(range(1 `ylim')) ///
          ylabel(1 (1) `pposition', angle(horizontal)) ///
          text(`pposition' 0.5 "p {&le} 0.01", place(c)) text(`pposition' 2.75 "p {&le} 0.01", place(c)) ///
          legend(off) ///
          graphregion(color(white)) ///
          saving(figure_6, replace)
   graph export "figure_6_english.pdf", as(pdf) replace
restore


/* figure 7 (a) english */
use "data_4.dta", clear

preserve
   collapse (mean) meanj = share_a (sd) sdj = share_a (count) n = share_a, by(scenario treatment)

   generate ci_high = meanj + invttail(n - 1, 0.05) * (sdj / sqrt(n))
   generate ci_low  = meanj - invttail(n - 1, 0.05) * (sdj/sqrt(n))

   generate tnr = .
      replace tnr = 0    if scenario == 0 & treatment == 0
      replace tnr = 1    if scenario == 0 & treatment == 1
      replace tnr = 2.25 if scenario == 1 & treatment == 0
      replace tnr = 3.25 if scenario == 1 & treatment == 1

   twoway (bar meanj tnr if treatment == 0, fcolor(gs10) lcolor(black) lwidth(medium) barwidth(0.9)) ///
          (bar meanj tnr if treatment == 1, fcolor(white) lcolor(black) lwidth(medium) barwidth(0.9)) ///
          (rcap ci_high ci_low tnr, lcolor(black)) ///
          (pci 0.717 -0.45 0.717 0.45, lcolor(black)) ///
          (pci 0.717  0.55 0.717 1.45, lcolor(black)) ///
          (pci 0.5    1.80 0.5   2.70, lcolor(black)) ///
          (pci 0.5    2.80 0.5   3.70, lcolor(black)) ///
          (pci 0.5   -0.45 0.5   0.45, lpattern(dash) lcolor(black)) ///
          (pci 0.5    0.55 0.5   1.45, lpattern(dash) lcolor(black)) ///
          (pci 0.283  1.80 0.283 2.70, lpattern(dash) lcolor(black)) ///
          (pci 0.283  2.80 0.283 3.70, lpattern(dash) lcolor(black)), ///
          title("") ///
          xtitle("Scenario and Group", size(large)) ///
          xlabel(0 `""Need," "Low" "Account.""' 1 `""Need," "High" "Account.""' 2.25 `""Productivity," "Low" "Account.""' 3.25 `""Productivity," "High" "Account.""', labsize(medlarge)) ///
          ytitle("Share", size(large)) ///
          yscale(range(0 (0.1) 0.7)) ///
          ylabel(0 "0" 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5" 0.6 "0.6" 0.7 "0.7", labsize(medlarge) angle(horizontal)) ///
          legend(off) ///
          graphregion(color(white)) ///
          saving(figure_7_a, replace)
   graph export "figure_7_a_english.pdf", as(pdf) replace
restore


/* figure 7 (b) english */
preserve
   gen deviation_a = .
      replace deviation_a = (share_a - 0.5) / (share_need_a - 0.5) if scenario == 0
      replace deviation_a = (0.5 - share_a) / (0.5 - share_productivity_a) if scenario == 1

   collapse (mean) meanj = deviation_a (sd) sdj = deviation_a (count) n = deviation_a, by(scenario treatment)

   generate ci_high = meanj + invttail(n - 1, 0.05) * (sdj / sqrt(n))
   generate ci_low  = meanj - invttail(n - 1, 0.05) * (sdj / sqrt(n))

   generate tnr = .
      replace tnr = 0    if scenario == 0 & treatment == 0
      replace tnr = 1    if scenario == 0 & treatment == 1
      replace tnr = 2.25 if scenario == 1 & treatment == 0
      replace tnr = 3.25 if scenario == 1 & treatment == 1

   twoway (rcap ci_high ci_low tnr, lcolor(black)) ///
          (scatter meanj tnr if treatment == 0, msymbol(square) mfcolor(gs10) mlcolor(black) msize(large)) ///
          (scatter meanj tnr if treatment == 1, msymbol(diamond) mfcolor(white) mlcolor(black) msize(large)), ///
          title("") ///
          xtitle("Scenario and Group", size(large)) ///
          xscale(range(-0.5 3.75)) ///
          xlabel(0 `""Need," "Low" "Account.""' 1 `""Need," "High" "Account.""' 2.25 `""Productivity," "Low" "Account.""' 3.25 `""Productivity," "High" "Account.""', labsize(medlarge)) ///
          ytitle("Deviation", size(large)) ///
          yscale(range(0 (0.1) 1.0)) ///
          ylabel(0 "0" 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5" 0.6 "0.6" 0.7 "0.7" 0.8 "0.8" 0.9 "0,9" 1 "1", labsize(medlarge) angle(horizontal)) ///
          legend(off) ///
          graphregion(color(white)) ///
          saving(figure_7_b, replace)
   graph export "figure_7_b_english.pdf", as(pdf) replace
restore


/* figure 7 (c) english */
preserve
   local ymin = 0.3
   local ymax = 0.9
   local pposition = 0.68
   local p1 = "p = 0.230"

   keep if scenario == 0

   replace case = mod(case - 1, 5) + 1

   collapse (mean) meanshare = share_a (sd) sdj = share_a (count) n = share_a, by(case treatment)

   generate ci_high = meanshare + invttail(n - 1, 0.05) * (sdj / sqrt(n))
   generate ci_low  = meanshare - invttail(n - 1, 0.05) * (sdj / sqrt(n))

   generate rescase = .
      replace rescase = (case - 1) * 2 + case if treatment == 0
      replace rescase = (case - 1) * 2 + case + 1 if treatment == 1

   twoway (bar meanshare rescase if treatment == 0, fcolor(gs10) lcolor(black) lwidth(medium)) ///
          (bar meanshare rescase if treatment == 1, fcolor(white) lcolor(black) lwidth(medium)) ///
          (rcap ci_high ci_low rescase, lcolor(black)) ///
          (pci 0.5   0.5 0.5   2.5, lpattern(dash) lcolor(black)) ///
          (pci 0.5   3.5 0.5   5.5, lpattern(dash) lcolor(black)) ///
          (pci 0.5   6.5 0.5   8.5, lpattern(dash) lcolor(black)) ///
          (pci 0.5   9.5 0.5  11.5, lpattern(dash) lcolor(black)) ///
          (pci 0.5  12.5 0.5  14.5, lpattern(dash) lcolor(black)) ///
          (pci 0.6   0.5 0.6   2.5, lpattern(solid) lcolor(black)) ///
          (pci 0.64  3.5 0.64  5.5, lpattern(solid) lcolor(black)) ///
          (pci 0.71  6.5 0.71  8.5, lpattern(solid) lcolor(black)) ///
          (pci 0.78  9.5 0.78 11.5, lpattern(solid) lcolor(black)) ///
          (pci 0.86 12.5 0.86 14.5, lpattern(solid) lcolor(black)), ///
          xtitle("Case (Need Scenario)", size(large)) ///
          xlabel(1.5 "1" 4.5 "2" 7.5 "3" 10.5 "4" 13.5 "5", labsize(medlarge)) ///
          ytitle("Share", size(large)) ///
          yscale(range(`ymin' (0.1) `ymax')) ///
          ylabel(0.3 "0.3" 0.4 "0.4" 0.5 "0.5" 0.6 "0.6" 0.7 "0.7" 0.8 "0.8" 0.9 "0.9", labsize(medlarge) angle(horizontal)) ///
          legend(off) ///
          graphregion(color(white)) ///
          saving(figure_7_c, replace)
   graph export "figure_7_c_english.pdf", as(pdf) replace
restore


/* figure 7 (d) english */
preserve
   local ymin = 0
   local ymax = 1

   gen deviation_a = .
      replace deviation_a = (share_a - 0.5) / (share_need_a - 0.5) if scenario == 0
      replace deviation_a = (0.5 - share_a) / (0.5 - share_productivity_a) if scenario == 1

   keep if scenario == 0

   replace case = mod(case - 1, 5) + 1

   collapse (mean) meanj = deviation_a (sd) sdj = deviation_a (count) n = deviation_a, by(case treatment)

   generate ci_high = meanj + invttail(n - 1, 0.05) * (sdj / sqrt(n))
   generate ci_low  = meanj - invttail(n - 1, 0.05) * (sdj / sqrt(n))

   generate rescase = .
      replace rescase = (case - 1) * 2 + case if treatment == 0
      replace rescase = (case - 1) * 2 + case + 1 if treatment == 1

   twoway (rcap ci_high ci_low rescase, lcolor(black)) ///
          (scatter meanj rescase if treatment == 0, msymbol(square) mfcolor(gs10) mlcolor(black) msize(large)) ///
          (scatter meanj rescase if treatment == 1, msymbol(diamond) mfcolor(white) mlcolor(black) msize(large)), ///
          xtitle("Case (Need Scenario)", size(large)) ///
          xscale(range(0.5 14.5)) ///
          xlabel(1.5 "1" 4.5 "2" 7.5 "3" 10.5 "4" 13.5 "5", labsize(medlarge)) ///
          ytitle("Deviation", size(large)) ///
          yscale(range(`ymin' (0.1) `ymax')) ///
          ylabel(0 "0" 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5" 0.6 "0.6" 0.7 "0.7" 0.8 "0.8" 0.9 "0.9" 1 "1", labsize(medlarge) angle(horizontal)) ///
          legend(off) ///
          graphregion(color(white)) ///
          saving(figure_7_d, replace)
   graph export "figure_7_d_english.pdf", as(pdf) replace
restore


/* figure 7 (e) english */
preserve
   local ymin = 0.0
   local ymax = 0.6
   local pposition = 0.53
   local p1 = "p {&le} 0.01"

   keep if scenario == 1

   replace case = mod(case - 1, 5) + 1

   collapse (mean) meanshare = share_a (sd) sdj = share_a (count) n = share_a, by(case treatment)

   generate ci_high = meanshare + invttail(n - 1, 0.05) * (sdj / sqrt(n))
   generate ci_low  = meanshare - invttail(n - 1, 0.05) * (sdj / sqrt(n))

   generate rescase = .
      replace rescase = (case - 1) * 2 + case if treatment == 0
      replace rescase = (case - 1) * 2 + case + 1 if treatment == 1

   twoway (bar meanshare rescase if treatment == 0, fcolor(gs10) lcolor(black) lwidth(medium)) ///
          (bar meanshare rescase if treatment == 1, fcolor(white) lcolor(black) lwidth(medium)) ///
          (rcap ci_high ci_low rescase, lcolor(black)) ///
          (pci 0.5   0.5 0.5   2.5, lpattern(solid) lcolor(black)) ///
          (pci 0.5   3.5 0.5   5.5, lpattern(solid) lcolor(black)) ///
          (pci 0.5   6.5 0.5   8.5, lpattern(solid) lcolor(black)) ///
          (pci 0.5   9.5 0.5  11.5, lpattern(solid) lcolor(black)) ///
          (pci 0.5  12.5 0.5  14.5, lpattern(solid) lcolor(black)) ///
          (pci 0.4   0.5 0.4   2.5, lpattern(dash) lcolor(black)) ///
          (pci 0.36  3.5 0.36  5.5, lpattern(dash) lcolor(black)) ///
          (pci 0.29  6.5 0.29  8.5, lpattern(dash) lcolor(black)) ///
          (pci 0.22  9.5 0.22 11.5, lpattern(dash) lcolor(black)) ///
          (pci 0.14 12.5 0.14 14.5, lpattern(dash) lcolor(black)), ///
          xtitle("Case (Productivity Scenario)", size(large)) ///
          xlabel(1.5 "1" 4.5 "2" 7.5 "3" 10.5 "4" 13.5 "5", labsize(medlarge)) ///
          ytitle("Share", size(large)) ///
          yscale(range(`ymin' (0.1) `ymax')) ///
          ylabel(0 "0" 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5" 0.6 "0.6", labsize(medlarge) angle(horizontal)) ///
          legend(off) ///
          graphregion(color(white)) ///
          saving(figure_7_e, replace)
   graph export "figure_7_e_english.pdf", as(pdf) replace
restore


/* figure 7 (f) english */
preserve
   local ymin = 0
   local ymax = 1

   gen deviation_a = .
      replace deviation_a = (share_a - 0.5) / (share_need_a - 0.5) if scenario == 0
      replace deviation_a = (0.5 - share_a) / (0.5 - share_productivity_a) if scenario == 1

   keep if scenario == 1

   replace case = mod(case - 1, 5) + 1

   collapse (mean) meanj = deviation_a (sd) sdj = deviation_a (count) n = deviation_a, by(case treatment)

   generate ci_high = meanj + invttail(n - 1, 0.05) * (sdj / sqrt(n))
   generate ci_low  = meanj - invttail(n - 1, 0.05) * (sdj / sqrt(n))

   generate rescase = .
      replace rescase = (case - 1) * 2 + case if treatment == 0
      replace rescase = (case - 1) * 2 + case + 1 if treatment == 1

   twoway (rcap ci_high ci_low rescase, lcolor(black)) ///
          (scatter meanj rescase if treatment == 0, msymbol(square) mfcolor(gs10) mlcolor(black) msize(large)) ///
          (scatter meanj rescase if treatment == 1, msymbol(diamond) mfcolor(white) mlcolor(black) msize(large)), ///
          xtitle("Case (Productivity Scenario)", size(large)) ///
          xscale(range(0.5 14.5)) ///
          xlabel(1.5 "1" 4.5 "2" 7.5 "3" 10.5 "4" 13.5 "5", labsize(medlarge)) ///
          ytitle("Abweichung", size(large)) ///
          yscale(range(`ymin' (0.1) `ymax')) ///
          ylabel(0 "0" 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5" 0.6 "0.6" 0.7 "0.7" 0.8 "0.8" 0.9 "0.9" 1 "1", labsize(medlarge) angle(horizontal)) ///
          legend(off) ///
          graphregion(color(white)) ///
          saving(figure_7_f, replace)
   graph export "figure_7_f_english.pdf", as(pdf) replace
restore


/* figure 8 (a) english */
* ssc install estout, replace
preserve
   xtset subject

   gen accountjudg = .
      replace accountjudg = accountability_need if scenario == 0
      replace accountjudg = accountability_productivity if scenario == 1

   xtreg share_a ///
      i.scenario##i.treatment##i.case ///
      age ///
      i.gender ///
      equivalent_household_net_income ///
      i.smoker ///
      i.cardiovascular_disease ///
      i.metabolic_disease ///
      locus_of_control ///
      political_attitude ///
      criteria_likert_need ///
      criteria_likert_productivity ///
      criteria_likert_equality ///
      accountjudg ///
      i.block_order#i.pos, ///
      re vce(robust) level(90)
      eststo shareacc_sce_dif_c

   margins i.case#i.treatment, dydx(scenario) level(90) saving(figure_7_a_margins, replace)

   margins i.scenario#i.treatment#i.case, post
   scalar sn1 = 2 * (0.5 - _b[0.scenario#0.treatment#1.case])
   scalar sn2 = 2 * (0.5 - _b[0.scenario#0.treatment#2.case])
   scalar sn3 = 2 * (0.5 - _b[0.scenario#0.treatment#3.case])
   scalar sn4 = 2 * (0.5 - _b[0.scenario#0.treatment#4.case])
   scalar sn5 = 2 * (0.5 - _b[0.scenario#0.treatment#5.case])
   scalar sp1 = 2 * (0.5 - _b[0.scenario#1.treatment#1.case])
   scalar sp2 = 2 * (0.5 - _b[0.scenario#1.treatment#2.case])
   scalar sp3 = 2 * (0.5 - _b[0.scenario#1.treatment#3.case])
   scalar sp4 = 2 * (0.5 - _b[0.scenario#1.treatment#4.case])
   scalar sp5 = 2 * (0.5 - _b[0.scenario#1.treatment#5.case])

   clear
   use figure_7_a_margins

   replace _m1 = _m1 + 0.2 if _m2 == 1

   twoway (rcap _ci_ub _ci_lb _m1, lcolor(black)) ///
          (scatter _margin _m1 if _m2 == 0, msymbol(square) mfcolor(gs10) mlcolor(black) msize(large)) ///
          (scatter _margin _m1 if _m2 == 1, msymbol(diamond) mfcolor(white) mlcolor(black) msize(large)) ///
          (pci `= sn1' 0.9 `= sn1' 1.1, lcolor(black) lwidth(thick)) ///
          (pci `= sn2' 1.9 `= sn2' 2.1, lcolor(black) lwidth(thick)) ///
          (pci `= sn3' 2.9 `= sn3' 3.1, lcolor(black) lwidth(thick)) ///
          (pci `= sn4' 3.9 `= sn4' 4.1, lcolor(black) lwidth(thick)) ///
          (pci `= sn5' 4.9 `= sn5' 5.1, lcolor(black) lwidth(thick)) ///
          (pci `= sp1' 1.1 `= sp1' 1.3, lcolor(black) lwidth(thick)) ///
          (pci `= sp2' 2.1 `= sp2' 2.3, lcolor(black) lwidth(thick)) ///
          (pci `= sp3' 3.1 `= sp3' 3.3, lcolor(black) lwidth(thick)) ///
          (pci `= sp4' 4.1 `= sp4' 4.3, lcolor(black) lwidth(thick)) ///
          (pci `= sp5' 5.1 `= sp5' 5.3, lcolor(black) lwidth(thick)), ///
          xtitle("Case", size(large)) ///
          xscale(range(0.75 5.5)) ///
          xlabel(1.1 "1" 2.1 "2" 3.1 "3" 4.1 "4" 5.1 "5", labsize(medlarge)) ///
          ytitle("Marginal Effect of" "Productivity Scenario on Share", size(large)) ///
          yscale(range(-0.2 (0.05) 0)) ///
          ylabel(-0.25 "– 0.25" -0.2 "– 0.20" -0.15 "– 0.15" -0.1 "– 0.10" -0.05 "– 0.05" 0 "0", labsize(medlarge) angle(horizontal)) ///
          yline(0, lcolor(black) lpattern(dash)) ///
          legend(order(2 "Low Accountability" 3 "High Accountability") size(medlarge) cols(1) ring(0) bplacement(swest)) ///
          graphregion(color(white)) ///
          saving(figure_8_a, replace)
   graph export "figure_8_a_english.pdf", as(pdf) replace
restore


/* figure 8 (b) english */
preserve
   gen deviation_a = .
      replace deviation_a = (share_a - share_productivity) / (share_need_a - share_productivity_a) if scenario == 0
      replace deviation_a = (share_need - share_a) / (share_need_a - share_productivity_a) if scenario == 1

   gen accountjudg = .
      replace accountjudg = accountability_need if scenario == 0
      replace accountjudg = accountability_productivity if scenario == 1

   xtset subject

   replace treatment = 2 if treatment == 1 & scenario == 1
   replace treatment = 1 if treatment == 0 & scenario == 1
   replace treatment = 0 if treatment == 2 & scenario == 1

   xtreg deviation_a ///
      i.treatment##i.scenario##i.case ///
      i.block_order#i.pos ///
      age ///
      i.gender ///
      equivalent_household_net_income ///
      i.smoker ///
      i.cardiovascular_disease ///
      i.metabolic_disease ///
      locus_of_control ///
      political_attitude ///
      criteria_likert_need ///
      criteria_likert_productivity ///
      criteria_likert_equality ///
	  accountjudg, ///
      re vce(robust) level(90)
      eststo devacc_sce_dif_c

   margins i.case#i.treatment, dydx(scenario) level(90) saving(figure_7_b_margins, replace)

   clear
   use figure_7_b_margins

   replace _m1 = _m1 + 0.2 if _m2 == 1

   twoway (rcap _ci_ub _ci_lb _m1, lcolor(black)) ///
          (scatter _margin _m1 if _m2 == 0, msymbol(square) mfcolor(gs10) mlcolor(black) msize(large)) ///
          (scatter _margin _m1 if _m2 == 1, msymbol(diamond) mfcolor(white) mlcolor(black) msize(large)), ///
          xtitle("Case", size(large)) ///
          xscale(range(0.75 5.5)) ///
          xlabel(1.1 "1" 2.1 "2" 3.1 "3" 4.1 "4" 5.1 "5", labsize(medlarge)) ///
          ytitle("Marginal Effect of" "Productivity Scenario on Deviation", size(large)) ///
          yscale(range(-0.6 (0.2) 0.4)) ///
          ylabel(-0.4 "– 0.4" -0.2 "– 0.2" 0 "0" 0.2 "0.2" 0.4 "0.4", labsize(medlarge) angle(horizontal)) ///
          yline(0, lcolor(black) lpattern(dash)) ///
          legend(order(2 "Low Accountability" 3 "High Accountability") size(medlarge) cols(1) ring(0) bplacement(swest)) ///
          graphregion(color(white)) ///
          saving(figure_8_b, replace)
   graph export "figure_8_b_english.pdf", replace
restore


/* figure 8 (c) english */
preserve
   xtset subject

   gen accountjudg = .
      replace accountjudg = accountability_need if scenario == 0
      replace accountjudg = accountability_productivity if scenario == 1

   xtreg share_a ///
      i.scenario##i.treatment##i.case ///
      age ///
      i.gender ///
      equivalent_household_net_income ///
      i.smoker ///
      i.cardiovascular_disease ///
      i.metabolic_disease ///
      locus_of_control ///
      political_attitude ///
      criteria_likert_need ///
      criteria_likert_productivity ///
      criteria_likert_equality ///
      accountjudg ///
      i.block_order#i.pos, ///
      re vce(robust) level(90)
      eststo sharescc_sce_dif_c

   margins i.scenario, dydx(i.treatment) at(case = 1) at(case = 2) at(case = 3) at(case = 4) at(case = 5) level(90) saving(figure_7_c_margins, replace)

   clear
   use figure_7_c_margins

   replace _at = _at + 0.2 if _m1 == 1

   twoway (rcap _ci_ub _ci_lb _at, lcolor(black)) ///
          (scatter _margin _at if _m1 == 0, msymbol(square) mfcolor(gs10) mlcolor(black) msize(large)) ///
          (scatter _margin _at if _m1 == 1, msymbol(diamond) mfcolor(white) mlcolor(black) msize(large)), ///
          xtitle("Case", size(large)) ///
          xscale(range(0.75 5.5)) ///
          xlabel(1.1 "1" 2.1 "2" 3.1 "3" 4.1 "4" 5.1 "5", labsize(medlarge)) ///
          ytitle("Marginal Effect of" "Accountability on Share", size(large)) ///
          ylabel(-0.15 "– 0.15" -0.1 "– 0.10" -0.05 "– 0.05" 0 "0" 0.05 "0.05", labsize(medlarge) angle(horizontal)) ///
          yline(0, lcolor(black) lpattern(dash)) ///
          legend(order(2 "Need Scenario" 3 "Productivity Scenario") size(medlarge) cols(1) ring(0) bplacement(swest)) ///
          graphregion(color(white)) ///
          saving(figure_8_c, replace)
   graph export "figure_8_c_english.pdf", replace
restore


/* figure 8 (d) english */
preserve
   gen deviation_a = .
      replace deviation_a = (share_a - share_productivity) / (share_need_a - share_productivity_a) if scenario == 0
      replace deviation_a = (share_need - share_a) / (share_need_a - share_productivity_a) if scenario == 1

   gen accountjudg = .
      replace accountjudg = accountability_need if scenario == 0
      replace accountjudg = accountability_productivity if scenario == 1

   xtset subject

   replace treatment = 2 if treatment == 1 & scenario == 1
   replace treatment = 1 if treatment == 0 & scenario == 1
   replace treatment = 0 if treatment == 2 & scenario == 1

   xtreg deviation_a ///
      i.treatment##i.scenario##i.case ///
      i.block_order#i.pos ///
      age ///
      i.gender ///
      equivalent_household_net_income ///
      i.smoker ///
      i.cardiovascular_disease ///
      i.metabolic_disease ///
      locus_of_control ///
      political_attitude ///
      criteria_likert_need ///
      criteria_likert_productivity ///
      criteria_likert_equality ///
      accountjudg, ///
      re vce(robust) level(90)
      eststo devacc_sce_dif_c

   margins i.scenario, dydx(i.treatment) at(case = 1) at(case = 2) at(case = 3) at(case = 4) at(case = 5) level(90) saving(figure_7_d_margins, replace)

   clear
   use figure_7_d_margins

   replace _at = _at + 0.2 if _m1 == 1

   twoway (rcap _ci_ub _ci_lb _at, lcolor(black)) ///
          (scatter _margin _at if _m1 == 0, msymbol(square) mfcolor(gs10) mlcolor(black) msize(large)) ///
          (scatter _margin _at if _m1 == 1, msymbol(diamond) mfcolor(white) mlcolor(black) msize(large)), ///
          xtitle("Case", size(large)) ///
          xscale(range(0.75 5.5)) ///
          xlabel(1.1 "1" 2.1 "2" 3.1 "3" 4.1 "4" 5.1 "5", labsize(medlarge)) ///
          ytitle("Marginal Effect of" "Accountability on Deviation", size(large)) ///
          yscale(range(-0.5 (0.1) 0)) ///
          ylabel(-0.5 "– 0.5" -0.4 "– 0.4" -0.3 "– 0.3" -0.2 "– 0.2" -0.1 "– 0.1" 0 "0", labsize(medlarge) angle(horizontal)) ///
          yline(0, lcolor(black) lpattern(dash)) ///
          legend(order(2 "Need Scenario" 3 "Productivity Scenario") size(medlarge) cols(1) ring(0) bplacement(swest)) ///
          graphregion(color(white)) ///
          saving(figure_8_d, replace)
   graph export "figure_8_d_english.pdf", as(pdf) replace
restore


/* figure 9 english */
preserve
   gen dectype = 0
      replace dectype = 1 if share_a <  share_productivity_a - 0.01
      replace dectype = 2 if share_a >= share_productivity_a - 0.01 & share_a <= share_productivity_a + 0.01
      replace dectype = 3 if share_a >  share_productivity_a + 0.01 & share_a <  share_need_a - 0.01
      replace dectype = 4 if share_a >= share_need_a - 0.01         & share_a <= share_need_a + 0.01
      replace dectype = 5 if share_a >  share_need_a + 0.01

   gen dectype2 = 0
      replace dectype2 = 1 if scenario == 0 & case == 1 & share_a >= 0.64  & share_a <= 0.66
      replace dectype2 = 1 if scenario == 0 & case == 2 & share_a >= 0.64  & share_a <= 0.66
      replace dectype2 = 1 if scenario == 0 & case == 3 & share_a >= 0.64  & share_a <= 0.66
      replace dectype2 = 1 if scenario == 0 & case == 4 & share_a >= 0.615 & share_a <= 0.635
      replace dectype2 = 1 if scenario == 0 & case == 5 & share_a >= 0.615 & share_a <= 0.635
      replace dectype2 = 1 if scenario == 1 & share_a >= (1 - share_productivity_a) - 0.01 & share_a <= (1 - share_productivity) + 0.01

   collapse (count) n = subject (sum) m = dectype2, by(dectype scenario treatment case)

   label define case_lb 1 "Case 1" 2 "Case 2" 3 "Case 3" 4 "Case 4" 5 "Case 5"
      label values case case_lb

   replace n = n / 91  if treatment == 0
   replace n = n / 109 if treatment == 1
   replace m = m / 91  if treatment == 0
   replace m = m / 109 if treatment == 1
   replace dectype = dectype + 0.4 if treatment == 1

   twoway (bar n dectype if treatment == 0 & scenario == 0, fcolor(gs10) lcolor(black) lpattern(solid) lwidth(medium) barwidth(0.4)) ///
          (bar n dectype if treatment == 1 & scenario == 0, fcolor(gs14) lcolor(black) lpattern(solid) lwidth(medium) barwidth(0.4)) ///
          (bar m dectype if scenario == 0, fcolor(gs3) lcolor(none) barwidth(0.4)), ///
          subtitle(, ring(0) pos(1) nobexpand fcolor(white) lcolor(white)) ///
          by(case, cols(1) graphregion(color(white)) note("") legend(pos(5))) ///
          xtitle("Need Scenario", size(large)) ///
          xlabel(1.2 "Less" 2.2 "Equal Split" 3.2 "Partial Compensation" 4.2 "Need Share" 5.2 "More", labsize(large) angle(forty_five)) ///
          ytitle("Relative Frequency", size(large)) ///
          ylabel(0 "0" 0.2 "0.2" 0.4 "0.4" 0.6 "0.6" 0.8 "0.8", labsize(large) angle(horizontal)) ///
          legend(order(3 "Net Split" 1 "Low Accountability") size(medlarge) region(lwidth(none)) col(2)) ///
          saving(figure_9_a, replace)

   twoway (bar n dectype if treatment == 0 & scenario == 1, fcolor(gs10) lcolor(black) lpattern(solid) lwidth(medium) barwidth(0.4)) ///
          (bar n dectype if treatment == 1 & scenario == 1, fcolor(gs14) lcolor(black) lpattern(solid) lwidth(medium) barwidth(0.4)) ///
          (bar m dectype if scenario == 1, fcolor(gs7) lcolor(none) barwidth(0.4)), ///
          subtitle(, ring(0) pos(1) nobexpand fcolor(white) lcolor(white)) ///
          by(case, cols(1) graphregion(color(white)) note("") legend(pos(7))) ///
          xtitle("Productivity Scenario", size(large)) ///
          xlabel(1.2 "Less" 2.2 "Productivity Share" 3.2 "Partial Compensation" 4.2 "Equal Split" 5.2 "More", labsize(large) angle(forty_five)) ///
          ytitle("") ///
          ylabel(0 "0" 0.2 "0.2" 0.4 "0.4" 0.6 "0.6" 0.8 "0.8", labsize(large) angle(horizontal)) ///
          legend(order(2 "High Accountability" 3 "Swap") size(medlarge) region(lwidth(none)) col(2)) ///
          saving(figure_9_b, replace)
          graph combine figure_9_a.gph figure_9_b.gph, col(2) graphregion(color(white)) xsize(4) altshrink ///
          saving(figure_9, replace)
   graph export "figure_9_english.pdf", as(pdf) replace
restore


/* figure 10 english */
preserve
   gen dectype = 0
      replace dectype = 1 if share_a <  share_productivity_a - 0.01
      replace dectype = 2 if share_a >= share_productivity_a - 0.01 & share_a <= share_productivity_a + 0.01
      replace dectype = 3 if share_a >  share_productivity_a + 0.01 & share_a <  share_need_a - 0.01
      replace dectype = 4 if share_a >= share_need_a - 0.01         & share_a <= share_need_a + 0.01
      replace dectype = 5 if share_a >  share_need_a + 0.01

   gen dectype2 = 0
      replace dectype2 = 1 if scenario == 0 & case == 1 & share_a >= 0.64  & share_a <= 0.66
      replace dectype2 = 1 if scenario == 0 & case == 2 & share_a >= 0.64  & share_a <= 0.66
      replace dectype2 = 1 if scenario == 0 & case == 3 & share_a >= 0.64  & share_a <= 0.66
      replace dectype2 = 1 if scenario == 0 & case == 4 & share_a >= 0.615 & share_a <= 0.635
      replace dectype2 = 1 if scenario == 0 & case == 5 & share_a >= 0.615 & share_a <= 0.635
      replace dectype2 = 1 if scenario == 1 & share_a >= (1 - share_productivity_a) - 0.01 & share_a <= (1 - share_productivity) + 0.01

   gen equald = 0
      replace equald = 1 if scenario == 0 & dectype == 2
      replace equald = 1 if scenario == 1 & dectype == 4

   gen propd = 0
      replace propd = 1 if scenario == 0 & dectype == 4
      replace propd = 1 if scenario == 1 & dectype == 2

   gen partd = 0
      replace partd = 1 if scenario == 0 & dectype == 3
      replace partd = 1 if scenario == 1 & dectype == 3

   gen netd = 0
      replace netd = 1 if scenario == 0 & dectype2 == 1
      replace netd = 1 if scenario == 1 & dectype2 == 1

   collapse (sum) equald propd partd netd (first) treatment, by(subject scenario)

   gen equaltyped = 0
      replace equaltyped = 1 if equald == 5

   gen proptyped = 0
      replace proptyped = 1 if propd == 5

   gen parttyped = 0
      replace parttyped = 1 if partd == 5

   gen nettyped = 0
      replace nettyped = 1 if netd == 5

   gen stypes = .
      replace stypes = 1 if equaltyped == 1
      replace stypes = 2 if parttyped == 1
      replace stypes = 3 if proptyped == 1
      replace stypes = 4 if nettyped == 1
      replace stypes = stypes + 0.4 if treatment == 1

   collapse (count) n = subject, by(stypes scenario treatment)

   replace n = n / 91 if treatment == 0
   replace n = n / 109 if treatment == 1

   drop if stypes == .

   twoway (bar n stype if treatment == 0 & scenario == 0, fcolor(gs10) lcolor(black) lpattern(solid) lwidth(medium) barwidth(0.4)) ///
          (bar n stype if treatment == 1 & scenario == 0, fcolor(gs14) lcolor(black) lpattern(solid) lwidth(medium) barwidth(0.4)), ///
          xtitle("Need Scenario", size(large)) ///
          xscale(range(0.7 4.5)) ///
          xlabel(1.2 "Equal Split" 2.2 "Partial Compensation" 3.2 "Need Share" 4.2 "Net Split", labsize(medlarge) angle(forty_five)) ///
          ytitle("Relative Frequency", size(large)) ///
          yscale(range(0 0.4)) ///
          ylabel(0 "0" 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4", labsize(medlarge) angle(horizontal)) ///
          legend(order(1 "Low Accountability") size(medlarge) region(lwidth(none)) col(1) pos(5)) ///
          graphregion(color(white)) ///
          saving(figure_10_a, replace)

   twoway (bar n stype if treatment == 0 & scenario == 1, fcolor(gs10) lcolor(black) lpattern(solid) lwidth(medium) barwidth(0.4)) ///
          (bar n stype if treatment == 1 & scenario == 1, fcolor(gs14) lcolor(black) lpattern(solid) lwidth(medium) barwidth(0.4)), ///
          xtitle("Productivity Scenario", size(large)) ///
          xlabel(1.2 "Equal Split" 2.2 "Partial Compensation" 3.2 "Productivity Share" 4.2 "Swap", labsize(medlarge) angle(forty_five)) ///
          xscale(range(0.7 4.5)) ///
          ytitle("") ///
          yscale(range(0 0.4)) ///
          ylabel(0 "0" 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4", labsize(medlarge) angle(horizontal)) ///
          legend(order(2 "High Accountability") size(medlarge) region(lwidth(none)) col(1) pos(7)) ///
          graphregion(color(white)) ///
          saving(figure_10_b, replace)

   graph combine figure_10_a.gph figure_10_b.gph, col(2) graphregion(color(white)) ycommon ///
      saving(figure_10, replace)
   graph export "figure_10_english.pdf", as(pdf) replace
restore


/* figure 15 english */
* ssc install cibar, replace
use "data_5.dta", clear

cibar eval, over1(kind_of_need) graphopts( ///
   xtitle("Kind of Need") ///
   xlabel(1 "Survival " 2 "Decency " 3 "Belonging " 4 "Autonomy ", angle(forty_five)) ///
   ytitle("Importance") ///
   ylabel(, angle(horizontal)) ///
   legend(off)) ///
   baropts(lcolor(black) lpattern(solid) lwidth(medium) graphregion(color(white)))
graph export "figure_15_english.pdf", as(pdf) replace


/* figure 16 english */
use "data_6.dta", clear

preserve
   label define productivity_english_lb 0 "Equal Productivity" 1 "Unequal Productivity"
      label values productivity productivity_english_lb

   label define kind_of_need_english_lb 1 "Survival" 2 "Decency" 3 "Belonging" 4 "Autonomy"
      label values kind_of_need kind_of_need_english_lb

   cibar allocation_diff, over2(kind_of_need) over1(productivity) graphopts( ///
      xtitle("Paired Case") ///
      xlabel(, angle(forty_five)) ///
      ytitle("Difference") ///
      ylabel(-300 "– 300" -200 "– 200" -100 "– 100" 0 "0" 100 "100", angle(horizontal))) ///
      baropts(lcolor(black) lpattern(solid) lwidth(medium) graphregion(color(white)))
   graph export "figure_16_english.pdf", as(pdf) replace
restore


/* figure 17 english */
use "data_7.dta", clear

preserve
   label define productivity_english_lb 0 "Equal Productivity" 1 "Unequal Productivity"
      label values productivity productivity_english_lb

   label define case_english_lb 0 "Survival – Autonomy" 1 "Survival – Belonging" 2 "Decency – Autonomy" 3 "Decency – Belonging" 4 "Survival – Decency" 5 "Belonging – Autonomy"
      label values case case_english_lb

   cibar allocation_diff, over2(case) over1(productivity) graphopts( ///
      xtitle("Mixed Case") ///
      xlabel(, angle(forty_five)) ///
      ytitle("Difference") ///
      ylabel(-200 "– 200" 0 "0" 200 "200" 400 "400" 600 "600", angle(horizontal))) ///
      baropts(lcolor(black) lpattern(solid) lwidth(medium) graphregion(color(white)))
   graph export "figure_17_english.pdf", as(pdf) replace
restore


/* figure 18 english */
set scheme s1color
global barchart_options = "lcolor(black) lpattern(solid) lwidth(medium)"

preserve
   label define productivity_english_lb 0 "Equal Productivity" 1 "Unequal Productivity"
      label values productivity productivity_english_lb

   reshape wide allocation_diff, i(id productivity) j(case)

   ren allocation_diff0 s_a
   ren allocation_diff1 s_b
   ren allocation_diff2 d_a
   ren allocation_diff3 d_b
   ren allocation_diff4 s_d
   ren allocation_diff5 b_a

   gen breakdown_sum_1 = s_a
   gen breakdown_sum_2 = s_b + b_a
   gen breakdown_sum_3 = s_d + d_a
   gen breakdown_sum_4 = s_d + d_b + b_a
   gen breakdown_sum_5 = d_a
   gen breakdown_sum_6 = d_b + b_a
   gen breakdown_sum_7 = s_b
   gen breakdown_sum_8 = s_d + d_b

   global breakdown_y_scale = "0 (200) 800"

   gen breakdown = 1

   forval i = 2/8 {
      expand 2 if breakdown == 1, gen(dupindicator)
      replace breakdown = `i' if dupindicator == 1
      drop dupindicator
   }

   replace s_a = . if breakdown != 1
   replace d_a = . if breakdown != 3 & breakdown != 5
   replace s_b = . if breakdown != 2 & breakdown != 7
   replace d_b = . if breakdown != 4 & breakdown != 6 & breakdown != 8
   replace s_d = . if breakdown != 3 & breakdown != 4 & breakdown != 8
   replace b_a = . if breakdown != 2 & breakdown != 4 & breakdown != 6

   collapse b_a d_b d_a s_d s_b s_a ///
      (mean)  mean_1 = breakdown_sum_1 mean_2 = breakdown_sum_2 mean_3 = breakdown_sum_3 mean_4 = breakdown_sum_4 mean_5 = breakdown_sum_5 mean_6 = breakdown_sum_6 mean_7 = breakdown_sum_7 mean_8 = breakdown_sum_8 ///
      (sd)    sd_1 = breakdown_sum_1 sd_2 = breakdown_sum_2 sd_3 = breakdown_sum_3 sd_4 = breakdown_sum_4 sd_5 = breakdown_sum_5 sd_6 = breakdown_sum_6 sd_7 = breakdown_sum_7 sd_8 = breakdown_sum_8 ///
      (count) n_1 = breakdown_sum_1 n_2 = breakdown_sum_2 n_3 = breakdown_sum_3 n_4 = breakdown_sum_4 n_5 = breakdown_sum_5 n_6 = breakdown_sum_6 n_7 = breakdown_sum_7 n_8 = breakdown_sum_8, ///
      by(breakdown productivity)

   label variable s_a "Survival – Autonomy"
   label variable s_b "Survival – Belonging"
   label variable d_a "Decency – Autonomy"
   label variable d_b "Decency – Belonging"
   label variable s_d "Survival – Decency"
   label variable b_a "Belonging – Autonomy"

   local tail_size = 0.05

   gen ci_low = .
   gen ci_high = .

   forval i=1/8 {
      replace ci_low  = mean_`i' - invttail(n_`i' / 2 - 1,`tail_size') * (sd_`i' / sqrt(n_`i' / 2)) if breakdown == `i'
      replace ci_high = mean_`i' + invttail(n_`i' / 2 - 1,`tail_size') * (sd_`i' / sqrt(n_`i' / 2)) if breakdown == `i'
   }

   replace s_b = s_b + b_a if breakdown == 2
   replace s_d = s_d + d_a if breakdown == 3
   replace s_d = s_d + d_b + b_a if breakdown == 4
   replace d_b = d_b + b_a if breakdown == 4 | breakdown == 6
   replace s_d = s_d + d_b if breakdown == 8

   twoway (bar s_a breakdown, $barchart_options) ///
          (bar s_b breakdown, $barchart_options) ///
          (bar s_d breakdown, $barchart_options) ///
          (bar d_a breakdown, $barchart_options) ///
          (bar d_b breakdown, $barchart_options) ///
          (bar b_a breakdown, $barchart_options) ///
          (rcap ci_high ci_low breakdown, lcolor(black)) ///
          if breakdown < 5, ///
          by(productivity, note("") graphregion(color(white))) ///
          xtitle("") ///
          xlabel(1 2 3 4) ///
          ytitle("Difference") ///
          ylabel($breakdown_y_scale, angle(0)) ///
          legend(order(1 2 3 4 5 6))
   graph export "figure_18_english.pdf", as(pdf) replace


/* figure 19 english */
   twoway (bar s_a breakdown, $barchart_options) ///
          (bar s_b breakdown, $barchart_options) ///
          (bar s_d breakdown, $barchart_options) ///
          (bar d_a breakdown, $barchart_options) ///
          (bar d_b breakdown, $barchart_options) ///
          (bar b_a breakdown, $barchart_options) ///
          (rcap ci_high ci_low breakdown, lcolor(black)) ///
          if breakdown > 4 & breakdown < 7, ///
          by(productivity, note("") graphregion(color(white))) ///
          xtitle("") ///
          xlabel(5 "1" 6 "2") ///
          ytitle("Difference") ///
          ylabel($breakdown_y_scale, angle(0)) ///
          legend(order(4 5 6))
   graph export "figure_19_english.pdf", as(pdf) replace


/* figure 20 english */
   twoway (bar s_a breakdown, $barchart_options) ///
          (bar s_b breakdown, $barchart_options) ///
          (bar s_d breakdown, $barchart_options) ///
          (bar d_a breakdown, $barchart_options) ///
          (bar d_b breakdown, $barchart_options) ///
          (bar b_a breakdown, $barchart_options) ///
          (rcap ci_high ci_low breakdown, lcolor(black)) ///
          if breakdown > 6, ///
          by(productivity, note("") graphregion(color(white))) ///
          xtitle("") ///
          xlabel(7 "1" 8 "2") ///
          ytitle("Difference") ///
          ylabel($breakdown_y_scale, angle(0)) ///
          legend(order(2 3 5))
   graph export "figure_20_english.pdf", as(pdf) replace
restore


exit
