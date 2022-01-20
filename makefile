a.out:lapcheck

lapcheck:
	perl lapcheck.pl > lapfiles
	emacsclient -n lapfiles
	rm lapfiles
