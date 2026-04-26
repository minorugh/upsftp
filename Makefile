.PHONY: git

git:
	@DATE=$$(date +"%Y-%m-%d %H:%M:%S"); \
	git add -A && \
	git diff --cached --quiet || git commit -m "auto: $$DATE"; \
	git push || true


sort:
	perl sort.pl

# ------------------------------------------------------------
# [Read-only] This file opens in read-only mode automatically.
# Toggle editable: C-c C-e  or  qq
# ------------------------------------------------------------
# Local Variables:
# buffer-read-only: t
# End:
