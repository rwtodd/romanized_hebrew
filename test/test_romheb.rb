require 'minitest/autorun'
require 'romanized_hebrew'

# Basic sanity test of RomanizedHebrew::convert
class RomHebTest < Minitest::Test
  def test_abg
    assert_equal "\u05d0", RomanizedHebrew::convert('A')
    assert_equal "\u05d1", RomanizedHebrew::convert('B')
    assert_equal "\u05d2", RomanizedHebrew::convert('G')
    assert_equal 'אבג', RomanizedHebrew::convert('ABG')
  end

  def test_html_output
    assert_equal '&#x5d0;', RomanizedHebrew::convert('A', format: :html)

    # ensure that it only converts the non-ascii output
    assert_equal '&#x5d0; and &#x5d1;', RomanizedHebrew::convert('A and B', format: :html)
  end

  def test_auto_finals
    assert_equal 'אן בנם', 
      RomanizedHebrew::convert('AN BNM')
    assert_equal '&#x5d0;&#x5df; &#x5d1;&#x5e0;&#x5dd;', 
      RomanizedHebrew::convert('AN BNM', format: :html)
    assert_equal 'אן בנם', 
      RomanizedHebrew::convert('ANf BNiMf')
  end

  def test_niqqud
    assert_equal '&#x5d1;&#x5b6;&#x5d0;&#x5dd;', RomanizedHebrew::convert('B3AM', format: :html)
    assert_equal "\u05d1\u05b6\u05d0\u05dd", RomanizedHebrew::convert('B3AM', format: :unicode)

    assert_equal "\u05d1\u05b6\u05bc\u05d0\u05de\u05bc\u05b1", 
      RomanizedHebrew::convert('B3*AMi*;3')
  end
end
