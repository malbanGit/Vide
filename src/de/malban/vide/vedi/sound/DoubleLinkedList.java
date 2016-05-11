/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vedi.sound;

/**
 *
 * @author salchr
 */
public class DoubleLinkedList 
{
    public static final int DLL_ADD_FRONT = 1;
    public static final int DLL_ADD_LAST = 2;
    
    DoubleLinkedListElement first = null;
    DoubleLinkedListElement last = null;

    static class DoubleLinkedListElement
    {
        Object object;
        int position;
        DoubleLinkedListElement previous;
        DoubleLinkedListElement next;
    }
    
    
    

    /***********************************************************************/
    /* Fuegt ein beliebiges Objekt in eine Liste ein, es wird ein Zeiger   */
    /* auf ein Objekt benoetigt                                            */
    /* Es wird in eine doppelt verkettete Liste eingefuegt, deren Anfang   */
    /* und ende jeweils auch ubergeben werden muessen                      */
    /* Da die ersten und letzten Listenelemente auch geaendert werden      */
    /* muessen dies Zeiger auf die Listen sein.                            */
    /***********************************************************************/
    public static boolean d_fuege_in_liste_ein( Object objekt, DoubleLinkedList list, int placement )
    {
        DoubleLinkedListElement neues = new DoubleLinkedListElement();

        if (list == null) return false;
        
        DoubleLinkedListElement hilfe = list.first;
        if ( placement == DLL_ADD_FRONT)
        {
            neues.position=0;
            while ( hilfe != null )
            {
               hilfe.position++;
               hilfe = hilfe.next;
            }
            neues.object = objekt;
            neues.previous = null;
            neues.next = list.first;                        /* vorne einfuegen */
            if ( list.last == null )
               list.last = neues;
            if ( list.first != null )
               list.first.previous = neues;
            list.first = neues;
        }
        if ( placement == DLL_ADD_LAST)
        {
            neues.object = objekt;
            neues.previous = list.last;                        /* hinten einfuegen */
            neues.next = null;
            neues.position=0;
            if ( list.first == null )
            {
                list.first = neues;
            }
            if ( list.last != null )
            {
                list.last.next = neues;
                neues.position=list.last.position+1;
            }
            list.last = neues;
        }
        return true;
    }

    /***********************************************************************/
    /* Die entsprechende Funktion um ein Element aus der Liste zu entfernen*/
    /***********************************************************************/
    public static boolean d_entferne_aus_liste( Object objekt, DoubleLinkedList list, boolean cleanup )
    {
        DoubleLinkedListElement hilfe = list.first;
        DoubleLinkedListElement dieses = null;
        while ( hilfe != null )
        {
           if ( hilfe.object == objekt )
           {
                dieses = hilfe;
                break;
           }
           hilfe = hilfe.next;
        }
        if (dieses == null)
        {
            return false;
        }

        /* Element der Liste bereinigen, sieht aufwendig aus, aber nur weil */
        /* verschiedene Faelle beruecksichtigt werden muessen               */
        hilfe=dieses;
        if (cleanup)
        {
            while ( hilfe != null )
            {
               hilfe.position--;
               hilfe = hilfe.next;
            }
        }
        if ( dieses != list.last )
        {
            if ( dieses != list.first )
            {
               hilfe = list.last;
               hilfe.next = dieses.next;
               hilfe = dieses.next;
               hilfe.previous = dieses.previous;
            }
            else
            {
               list.first = dieses.next;
               list.first.previous = null;
            }
        }
        else
        {
            if ( dieses != list.first )
            {
               hilfe = dieses.previous;
               hilfe.next = null;
               list.last = dieses.previous;
            }
            else
            {
               list.first = null;
              list.last = null;
            }
        }
        return true;
    }

    /***********************************************************************/
    /* gibt die Anzahl der Listenelemente zurueck, Eingabeparameter ist im */
    /* allgemeinen, das erste element der Liste, da dies zur               */
    /* Anzahlberechnung verwendet wird                                     */
    /***********************************************************************/
    public static int d_anzahl_liste(DoubleLinkedList list )
    {
        return d_anzahl_liste(list.first );
    }
    public static int d_anzahl_liste(DoubleLinkedListElement element )
    {
        int i = 0;
        while ( element != null )
        {
            i++;
            element = element.next;
        }
        return i;
    }

    /***********************************************************************/
    /* Wandelt eine Liste in ein entsprechende Array, die Liste wird nicht */
    /* geloescht                                                           */
    /* Platz fuer array wird mit malloc ermittelt                          */
    /***********************************************************************/
    public static Object[] d_liste_to_array( DoubleLinkedList list )
    {
        return d_liste_to_array( list.first );
    }
    public static Object[] d_liste_to_array( DoubleLinkedListElement list )
    {
        DoubleLinkedListElement hilfe = list;
        Object[] array = null;
        int i = 0;
        int anzahl = d_anzahl_liste(list);
        if ( anzahl == 0 )
        {
            return null;
        }
        array = new Object[anzahl];
        while ( hilfe != null )
        {
            array[ i++ ] = hilfe.object;
            hilfe = hilfe.next;
        }
        return array;
    }

    /***********************************************************************/
    public static DoubleLinkedListElement d_get_list_pos(Object objekt, DoubleLinkedList list)
    {
        return d_get_list_pos(objekt, list.first);
    }

    public static DoubleLinkedListElement d_get_list_pos(Object objekt, DoubleLinkedListElement erstes)
    {
        while (erstes!=null)
        {
            if (erstes.object==objekt)
            {
               return erstes;
            }
            erstes=erstes.next;
        }
        return null;
    }

    /***********************************************************************/
    // liefert werte,
    // erstes zuerst in liste == 1
    // erstes gleich zweites == 0
    // erstes danach in der liste  -1
    public static int d_vergleich(Object objekt1, Object objekt2, DoubleLinkedList erstes)
    {
        return d_vergleich( objekt1, objekt2,  erstes.first);
    }
    public static int d_vergleich(Object objekt1,Object objekt2, DoubleLinkedListElement erstes)
    {
        while (erstes!=null)
        {
            if (erstes.object==objekt1)
                if (erstes.object==objekt2)
                {
                   return 0;
                }
                else
                {
                   return 1;
                }
            else
                if (erstes.object==objekt2)
                {
                    return -1;
                }
            erstes=erstes.next;
        }
        return 2;
    }
    /***********************************************************************/
    public static boolean d_fuege_in_liste_ein_past_position(Object welches, Object wohin, DoubleLinkedList list)
    {
        DoubleLinkedListElement hilfe = null;
        DoubleLinkedListElement naechstes = null;
        DoubleLinkedListElement hilfe2 = null;
        DoubleLinkedListElement neues = null;
        if ((list.first==null)||(list.last==null))
        {
           return false;
        }
        neues = new DoubleLinkedListElement();

        hilfe=d_get_list_pos(wohin, list);
        if (hilfe==null)
        {
           return false;
        }
        naechstes=hilfe.next;
        neues.object = welches;
        neues.previous = hilfe;                        /* hinten einfuegen */
        neues.next = naechstes;
        neues.position=-1;
        if ( list.first == null )
        {
            list.first = neues;
            neues.position=0;
        }
        if ( list.last == null )
        {
            list.last=neues;
        }
        if (hilfe!=null)
        {
            hilfe.next=neues;
            neues.position=hilfe.position+1;
        }
        if (naechstes!=null)
        {
            naechstes.previous=neues;
            hilfe2=naechstes;
            while ( hilfe2 != null )
            {
               hilfe2.position++;
               hilfe2 = hilfe2.next;
            }
        }
        else // dann ist hilfe das letzte gewesen
        {
            list.last=neues;
        }

        return true;
    }

    /***********************************************************************/

    public static boolean d_vertausche_hoch(Object objekt, DoubleLinkedList list)
    {
        return d_vertausche_hoch(objekt, list.first);
    }
    public static boolean d_vertausche_hoch(Object objekt,DoubleLinkedListElement liste)
    {
        liste=d_get_list_pos(objekt, liste);
        if ((liste!=null)&&(objekt!=null)&&(liste.previous!=null))
        {
            liste.object=liste.previous.object;
            liste.previous.object=objekt;
            return true;
        }
        return false;
    }

    /***********************************************************************/

    public static boolean d_vertausche_runter(Object objekt, DoubleLinkedList list)
    {
        return d_vertausche_runter(objekt, list.first);
    }
    public static boolean d_vertausche_runter(Object objekt,DoubleLinkedListElement liste)
    {
        liste=d_get_list_pos(objekt,liste);
        if ((liste!=null)&&(objekt!=null)&&(liste.next!=null))
        {
            liste.object=liste.next.object;
            liste.next.object=objekt;
            return true;
        }
        return false;
    }
}
