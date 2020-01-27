// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy;


public class Comment implements LineRecognizer {

        public boolean recognizes( ParseString s ) 
        {
            int p0 = s.getPosition();
            s.skipSpaces();

            if (s.length() > 0)
            {
                if ((s.charAt(0) != '*') && (s.charAt(0) != ';'))
                {
                    s.setPosition(p0);
                    return false;

                }
            }		
            return true;
        }
        
        // returns line comment
        // removes comment from parse String
        public static String removeEndOfLineComment(ParseString s)
        {
            // "YOU'LL NEVER REACH HOME..." ; 15  -77 0xb3
            // tricky!
            int posSemicolon = s.buffer.substring(0).indexOf(";");
            if (posSemicolon<0)posSemicolon = Integer.MAX_VALUE;
            if (posSemicolon==Integer.MAX_VALUE) return "";
            
            int posDouble = s.buffer.substring(0).indexOf("\"");
            int posSingle = s.buffer.substring(0).indexOf("'");
            if (posSingle<0)posSingle = Integer.MAX_VALUE;
            if (posDouble<0)posDouble = Integer.MAX_VALUE;
            
            if ((posSemicolon<posDouble) && (posSemicolon<posSingle))
            {
                String ret = s.removeFrom(posSemicolon);
                ret = ret.trim();
                ret = ret.substring(1);
                ret = ret.trim();
                return ret;
            }
            
            // now, we have a semicolon 
            // and we have open chars befor it!
            String wc = s.buffer.substring(0); // working copy

            boolean enough = false;
            do
            {
                wc = removeOneQuote(wc);
                if (wc == null)
                {
                    return "";
                }
                posDouble = wc.indexOf("\"");
                posSingle = wc.indexOf("'");
                posSemicolon = wc.indexOf(";");
                if (posSemicolon<0)posSemicolon = Integer.MAX_VALUE;
                if (posSemicolon==Integer.MAX_VALUE) return "";
                if (posSingle<0)posSingle = Integer.MAX_VALUE;
                if (posDouble<0)posDouble = Integer.MAX_VALUE;
                enough = ((posSemicolon<posDouble) && (posSemicolon<posSingle));
            } while (!enough);
            // now we have string that contains somewhere a semicolon
            // and no opening chars befor it

            String semiString = wc.substring(wc.indexOf(";"));
            
            String ret = s.removeFrom(s.buffer.indexOf(semiString));
            
            ret = ret.trim();
            ret = ret.substring(1);
            ret = ret.trim();
            return ret;
        }
        public String removeFrom(String s, int pos)
        {
            if (pos >=s.length()) return "";
            if (pos <0) return "";
            String ret = s.substring(pos);
            s = s.substring(0, pos);
            return ret;
        }
        // returns line without comment
        public static String removeEndOfLineComment(String s)
        {
            // "YOU'LL NEVER REACH HOME..." ; 15  -77 0xb3
            // tricky!
            int posSemicolon = s.substring(0).indexOf(";");
            if (posSemicolon<0)posSemicolon = Integer.MAX_VALUE;
            if (posSemicolon==Integer.MAX_VALUE) return s;
            
            int posDouble = s.substring(0).indexOf("\"");
            int posSingle = s.substring(0).indexOf("'");
            if (posSingle<0)posSingle = Integer.MAX_VALUE;
            if (posDouble<0)posDouble = Integer.MAX_VALUE;
            
            if ((posSemicolon<posDouble) && (posSemicolon<posSingle))
            {
                if (posSemicolon == Integer.MAX_VALUE)
                    return s;
                return s.substring(0, s.indexOf(";"));
            }
            
            // now, we have a semicolon 
            // and we have open chars befor it!
            String wc = s.substring(0); // working copy

            boolean enough = false;
            do
            {
                wc = removeOneQuote(wc);
                if (wc == null)
                {
                    return "";
                }
                posDouble = wc.indexOf("\"");
                posSingle = wc.indexOf("'");
                posSemicolon = wc.indexOf(";");
                if (posSemicolon<0)posSemicolon = Integer.MAX_VALUE;
                if (posSemicolon==Integer.MAX_VALUE) return s;
                if (posSingle<0)posSingle = Integer.MAX_VALUE;
                if (posDouble<0)posDouble = Integer.MAX_VALUE;
                enough = ((posSemicolon<posDouble) && (posSemicolon<posSingle));
            } while (!enough);
            // now we have string that contains somewhere a semicolon
            // and no opening chars befor it

            String semiString = wc.substring(wc.indexOf(";"));
            
            return  s.substring(0, s.indexOf(semiString));
        }
                // returns line without comment
        public static String removeCEndOfLineComment(String s)
        {
            // "YOU'LL NEVER REACH HOME..." ; 15  -77 0xb3
            // tricky!
            int posSemicolon = s.substring(0).indexOf("//");
            if (posSemicolon<0)posSemicolon = Integer.MAX_VALUE;
            if (posSemicolon==Integer.MAX_VALUE) return s;
            
            int posDouble = s.substring(0).indexOf("\"");
            int posSingle = s.substring(0).indexOf("'");
            if (posSingle<0)posSingle = Integer.MAX_VALUE;
            if (posDouble<0)posDouble = Integer.MAX_VALUE;
            
            if ((posSemicolon<posDouble) && (posSemicolon<posSingle))
            {
                if (posSemicolon == Integer.MAX_VALUE)
                    return s;
                return s.substring(0, s.indexOf("//"));
            }
            
            // now, we have a semicolon 
            // and we have open chars befor it!
            String wc = s.substring(0); // working copy

            boolean enough = false;
            do
            {
                wc = removeOneQuote(wc);
                if (wc == null)
                {
                    return "";
                }
                posDouble = wc.indexOf("\"");
                posSingle = wc.indexOf("'");
                posSemicolon = wc.indexOf("//");
                if (posSemicolon<0)posSemicolon = Integer.MAX_VALUE;
                if (posSemicolon==Integer.MAX_VALUE) return s;
                if (posSingle<0)posSingle = Integer.MAX_VALUE;
                if (posDouble<0)posDouble = Integer.MAX_VALUE;
                enough = ((posSemicolon<posDouble) && (posSemicolon<posSingle));
            } while (!enough);
            // now we have string that contains somewhere a semicolon
            // and no opening chars befor it

            String semiString = wc.substring(wc.indexOf("//"));
            
            return  s.substring(0, s.indexOf(semiString));
        }
        
                // returns line without comment
        public static String removeC1EndOfLineComment(String s)
        {
            // "YOU'LL NEVER REACH HOME..." ; 15  -77 0xb3
            // tricky!
            int posSemicolon = s.substring(0).indexOf("/*");
            if (posSemicolon<0)posSemicolon = Integer.MAX_VALUE;
            if (posSemicolon==Integer.MAX_VALUE) return s;
            
            int posDouble = s.substring(0).indexOf("\"");
            int posSingle = s.substring(0).indexOf("'");
            if (posSingle<0)posSingle = Integer.MAX_VALUE;
            if (posDouble<0)posDouble = Integer.MAX_VALUE;
            
            if ((posSemicolon<posDouble) && (posSemicolon<posSingle))
            {
                if (posSemicolon == Integer.MAX_VALUE)
                    return s;
                return s.substring(0, s.indexOf("/*"));
            }
            
            // now, we have a semicolon 
            // and we have open chars befor it!
            String wc = s.substring(0); // working copy

            boolean enough = false;
            do
            {
                wc = removeOneQuote(wc);
                if (wc == null)
                {
                    return "";
                }
                posDouble = wc.indexOf("\"");
                posSingle = wc.indexOf("'");
                posSemicolon = wc.indexOf("/*");
                if (posSemicolon<0)posSemicolon = Integer.MAX_VALUE;
                if (posSemicolon==Integer.MAX_VALUE) return s;
                if (posSingle<0)posSingle = Integer.MAX_VALUE;
                if (posDouble<0)posDouble = Integer.MAX_VALUE;
                enough = ((posSemicolon<posDouble) && (posSemicolon<posSingle));
            } while (!enough);
            // now we have string that contains somewhere a semicolon
            // and no opening chars befor it

            String semiString = wc.substring(wc.indexOf("/*"));
            
            return  s.substring(0, s.indexOf(semiString));
        }
        static String  removeOneQuote(String wc)
        {
            int posDouble = wc.indexOf("\"");
            int posSingle = wc.indexOf("'");
            if (posSingle<0)posSingle = Integer.MAX_VALUE;
            if (posDouble<0)posDouble = Integer.MAX_VALUE;

            char quoteChar = 0;
            if (posDouble<posSingle)
                quoteChar = '\"';
            else
                quoteChar = '\'';
        
            wc = wc.substring(wc.indexOf(""+quoteChar)+1,wc.length());
            // wc start after opening quote
            
            int i=0;
            boolean found = false;
            boolean escapeFound = false;
            while (i<wc.length())
            {
                char c= wc.charAt(i);
                if (c == '\\')
                {
                    if (!escapeFound)
                        escapeFound = true;
                    else
                        escapeFound = false;
                    i++;
                    continue;
                }
                if (c == quoteChar)
                {
                    if (!escapeFound)
                    {
                        found = true;
                        break;
                    }
                }
                i++;
                escapeFound = false;
            }
            if (found == false) return null; // string not terminated error!
            return wc.substring(i+1);
        }
        
            
            
        
        
}

