/* _alloc.h */

/* DECUS C void definition */

#undef	VOID

#ifdef	DECUS
#define	VOID	char
#endif

/* PDOS C void definition */

#ifdef	PDOS
#define	VOID	char
#endif

/* Default void definition */

#ifndef	VOID
#define	VOID	void
#endif


extern	VOID	*alloc();
extern	VOID	*malloc();
extern	VOID	*calloc();
extern	VOID	*realloc();
extern	int	free();


