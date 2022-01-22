a.out:sort lapcheck

sort:
	perl sort.pl

lapcheck:
	perl lapcheck.pl > lapfiles
	emacsclient -n lapfiles
	rm lapfiles
