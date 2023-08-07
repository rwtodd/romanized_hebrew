# Romanized Hebrew library

# RomanizedHebrew converts the romanization menthod used by the
# English occultists of the 19th and 20th centuries. It is as follows:
#
#   A  = aleph   B  = beth    G  = gimel    D  = dalet
#   H  = heh     V  = vav     Z  = zayin    Ch = chet
#   T  = teth    I  = yod     K  = kaf      L  = lamed
#   M  = mem     N  = nun     S  = samekh   O  = ayin
#   P  = peh     Tz = tzaddi  Q  = qoph     R  = resh
#   Sh = shin    Th = tav
# 
#   Ligatures:
#   Ii = yod-yod   Vi = vav-yod     Vv = vav-vav
# 
#   Niqqud:
#   ;  = Sh'va                *  = Dagesh
#   \\ =  Kubutz              `  = Holam
#   1  = Hiriq                2  = Zeire                
#   3  = Segol                ;3 = Reduced Segol        
#   _  = Patach               ;_ = Reduced Patach       
#   7  = Kamatz               ;7 = Reduced Kamatz       
#   Shl = Shin dot left       Shr = Shin dot right
#       ;; = escape an actual semicolon
# 
# Letters which can be final can take a 'f' or 'i' prefix to
# force the interpretation to be 'final' or 'initial'... otherwise
# a letter at the end of a word is considered final.
class RomanizedHebrew
  NIQQUD = %r!;[;37_]?  |  [1237_*\\`]!x
  INFERRED_FINAL = %r!
     (?:K|M|N|P|Tz)  # one of the possibly-final letters
     (?= #{NIQQUD}*+   # looking at niqqod
        (?:\W|\Z))     # ... followed by a non-word or end-of-line
  !x
  TRANSLITERATE = %r!
    ([A-Z][fhilvz]*+)          # consonant (and Shin dots)
    (#{NIQQUD}?+)(#{NIQQUD}?+) # possible niqqud 
  !x

  @trans_tbl = {   # transliteration table
    # aleph, beth, gimel, dalet
    'A' => "\u05d0", 'B' => "\u05d1", 'G' => "\u05d2", 'D' => "\u05d3",    
    # heh, vav, zain, cheth
    'H' => "\u05d4", 'V' => "\u05d5", 'Z' => "\u05d6", 'Ch' => "\u05d7",
    # tayt, yod, kaf_final, kaf, kaf_initial
    'T' => "\u05d8", 'I' => "\u05d9", 'Kf' => "\u05da", 'K' => "\u05db",  'Ki' => "\u05db",  
    # lamed, mem_final, mem, mem_initial, nun_final
    'L' => "\u05dc", 'Mf' => "\u05dd", 'M' => "\u05de", 'Mi' => "\u05de", 'Nf' => "\u05df",  
    # nun, samekh, ayin, peh_final
    'N' => "\u05e0", 'Ni' => "\u05e0", 'S' => "\u05e1", 'O' => "\u05e2", 'Pf' => "\u05e3", 
    # peh, peh_initial, tzaddi_final, tzaddi, tzaddi_initial 
    'P' => "\u05e4", 'Pi' => "\u05e4", 'Tzf' => "\u05e5", 'Tz' => "\u05e6", 'Tzi' => "\u05e6", 
    # qoph, resh, shin, tav
    'Q' => "\u05e7",  'R' => "\u05e8", 'Sh' => "\u05e9", 'Th' => "\u05ea",  
    # Ligatures
    # doube-yod, double-vav, vav-yod
    'Ii' => "\u05f2", 'Vv' => "\u05f0", 'Vi' => "\u05f1",
    # niqqud
    ';;' => ';',      # escape an actual semicolon
    ';' => "\u05b0",  # Sh'va 
    ';3' => "\u05b1", # Reduced Segol
    ';_' => "\u05b2", # Reduced Patach
    ';7' => "\u05b3", # Reduced Kamatz
    '1' => "\u05b4",  # Hiriq
    '2' => "\u05b5",  # Zeire
    '3' => "\u05b6",  # Segol
    '_' => "\u05b7",  # Patach
    '7' => "\u05b8",  # Kamatz
    '*' => "\u05bc",  # Dagesh
    '\\' => "\u05bb", # Kubutz
    '`' => "\u05b9",  # Holam
    'Shl' => "\u05e9\u05c2", # Shin dot left
    'Shr' => "\u05e9\u05c1"  # Shin dot right
  }
  @trans_tbl.default_proc = Proc.new {|h,k| k } # identity when unknown chars appear

  # Convert a romanized hebrew string, `rom`, to actual hebrew.  If the format is set to
  # `:html`, then the output is a series of hexadecimal html entities, which can be
  # easier to work with than mixing RTL and LTR languages in a file.
  #
  #  RomanizedHebrew.convert('ABG')                 # => אבג
  #  RomanizedHebrew.convert('ABG', format: :html)  # => &#x5d0;&#x5d1;&#x5d2; 
  def self.convert(rom, format: :unicode)
    # first, add automatic final letters
    hebrew = rom.gsub(INFERRED_FINAL, '\0f')
    # second, perform the transliteration
    hebrew.gsub!(TRANSLITERATE) do |m|
      "#{@trans_tbl[$1]}#{@trans_tbl[$2]}#{@trans_tbl[$3]}"
    end
    # finally, convert to html entities if needed
    if format == :html then
      hebrew = hebrew.codepoints.map do |cp|
        cp > 127 ? "&\#x#{cp.to_s(16)};" : cp.chr
      end.join('')
    end
    hebrew
  end

end
