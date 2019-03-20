/* common.c */


static FILE *sfp = NULL;



static void *new(unsigned int n)
{
	char *p;

	p = (char *)calloc(n, sizeof(char));
	if (!p) {
		fprintf(stderr, "Error: out of space!\n");
		exit(1);
	}

	return p;
}



static struct lfile *new_lfile(char *filename, char arch)
{
	struct lfile *lfilep;

	lfilep = (struct lfile *)new(sizeof(struct lfile));
	lfilep->f_idp = (char *)new(strlen(filename)+1);
	strcpy(lfilep->f_idp, filename);
	lfilep->f_arch = arch;

	return lfilep;
}



/* striplineend:
 *  Strip newline and carriage-return at end of line.
 */
static void striplineend(char *str)
{
	int i;
	i = strlen(str);
	if (i > 0) {
		if (str[i-1] == '\n')
			str[--i] = 0;
		if (i > 0) {
			if (str[--i] == '\r')
				str[i] = 0;
		}
	}
}



/* skipheader:
 *  Skip header and symbol index.
 */
static void skipheader(FILE *fp)
{
	char *str;
	long offset = 0;
	while (FGETS(ib, sizeof(ib), fp) != NULL) {
		striplineend(ib);
		/* process header */
		if (*ib == '#') {
			offset = FTELL(fp);
			continue;
		}
		/* process symbol index */
		do {
			striplineend(ib);
			str = strchr(ib, ' ');
			if (!*ib || (str && strchr(str+1, ' '))) {
				offset = FTELL(fp);
				continue;
			}
			if (strncmp(ib, tag_libbeg, tag_libsz)) {
				str = strchr(ib, ' ');
				if (str)
					*str = 0;
				fprintf(stderr, "Error: wrong archive format '%s'.\n", ib);
				exit(1);
			}
			break;
		} while (FGETS(ib, sizeof(ib), fp) != NULL);
		break;
	}
	if (FSEEK(fp, offset, SEEK_SET) < 0) {
		fprintf(stderr, "Error: cannot seek archive.\n");
		exit(1);
	}
}



static int get(void)
{
	int c;

	if ((c = *ip) != 0)
		++ip;

	return c;
}



static int getnb(void)
{
	int c;

	while ((c=get())==' ');

	return c;
}



static void getid(char *id, int c)
{
	char *p;

	if (c < 0)
		c = getnb();

	p = id;

	do {
		if (p < &id[NCPS-1])
			*p++ = c;
	} while ((ctype[c=get()] & (LETTER|DIGIT)) || (c == '-'));

	if (c != 0)
		--ip;

	*p = 0;
}



static long as_offset(void)
{
	return cfp->f_arch ? FTELL(sfp) : ftell(sfp);
}



static int nxtline(void)
{
	int ret;
	ret = 1;

loop:
	if (sfp == NULL ||
			(!cfp->f_arch && fgets(ib, sizeof(ib), sfp) == NULL) ||
			 (cfp->f_arch && FGETS(ib, sizeof(ib), sfp) == NULL)) {
		/* close just finished file */
		if (sfp != NULL) {
			if (!cfp->f_arch)
				fclose(sfp);
			else
				FCLOSE(sfp);
			sfp = NULL;
		}

		/* advance current file */
		if (cfp == NULL)
			cfp = filep;
		else
			cfp = cfp->f_flp;

		/* open new file */
		if (cfp != NULL) {
#ifdef VERBOSE_LEVEL
			if (verbose_level && verbose_action)
				fprintf(stdout, "%c - %s\n", verbose_action, cfp->f_idp);
#endif
			if (!cfp->f_arch)
				sfp = fopen(cfp->f_idp, "r");
			else
				sfp = FOPEN(cfp->f_idp, "r");
			if (!sfp) {
				fprintf(stderr, "Error: cannot open '%s'.\n", cfp->f_idp);
				exit(1);
			}
			if (cfp->f_arch)
				skipheader(sfp);
			ret = 2;
			goto loop;
		}
		else {
			return 0;
		}
	}

	striplineend(ib);

	return ret;
}
