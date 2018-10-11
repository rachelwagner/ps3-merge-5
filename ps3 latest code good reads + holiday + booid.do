//Problem Set 3 
//Rachel Wagner 
//October 11 2018

//version 15
pwd 
ls
cd DirectedStudy
ls

//importing Good Reads Sample 
use https://github.com/rachelwagner/ps3-merge-5/raw/master/100ksample1goodreads.dta, clear 
 l datadd in 1/100
//making the date in this data read like the date in holidays data :) 
gen year=substr(datadd, -5,4) 
gen daymo=substr(datadd, 5,6) 
gen mo1=substr(daymo, 1,3)
gen day1=substr(daymo, -2,2)
l datadd year daymo mo1 day1 in 1/10
// Replacing month words with month numbers ("Jan" to "1") 
gen mo2=""
replace mo2="01" if mo1=="Jan"
replace mo2="02" if mo1=="Feb"
replace mo2="03" if mo1=="Mar"
replace mo2="04" if mo1=="Apr"
replace mo2="05" if mo1=="May"
replace mo2="06" if mo1=="Jun"
replace mo2="07" if mo1=="Jul"
replace mo2="08" if mo1=="Aug"
replace mo2="09" if mo1=="Sep"
replace mo2="10" if mo1=="Oct"
replace mo2="11" if mo1=="Nov"
replace mo2="12" if mo1=="Dec"
gen date=year+"-"+mo2+"-"+day1
ta date // it worked!
save dayMoYr, replace 

insheet using https://raw.githubusercontent.com/rachelwagner/ps3-merge-5/master/usholidays.csv,clear name
 //2018-02-19
 ta date in 1/100
 count if date==date[_n-1]
 l if date==date[_n-1]
 drop if date=="1989-11-11" & v1==327
 
merge 1:m date using dayMoYr

l date if _merge==1
ta date if _merge==2

drop if _merge==2
sort booid
drop if booid==booid[_n-1]
drop _merge

save goodreadsholidaymerge, replace 

//Merge booid with goodreadsholidays :)
use https://github.com/rachelwagner/ps3-merge-5/raw/master/ratingsgoodbooksample.dta, clear
rename book_id booid
cap drop _merge //supress error 
merge m:1 booid using goodreadsholidaymerge


save goodreadsholidaybooidmerge, replace 

l booid if _merge==1 //repeated obs because there's going to be reviews on the same bookid
l booid if _merge==2 // "1.4e+06" for most of using unmatched obs 

//dropping unmatched 
drop if _merge==1
drop if _merge==2 

save goodreadsholidaybooidmerge, replace //saves matched obs 



