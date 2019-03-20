/* alloc.h */

#undef	VOID

/* DECUS C void definition */

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


