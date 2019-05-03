require 'minitest/autorun'
require 'dicom_uid'

class DicomUIDTest < Minitest::Test


  def setup

    @p_true = DicomUID.random_component 2, true
    @p_false = DicomUID.random_component 2, false
    @no_param = DicomUID.random_component
    @one_param = DicomUID.random_component 2

  end


  def test_random_component_is_string
    assert_kind_of String, @p_true
    assert_kind_of String, @p_false
    assert_kind_of String, @no_param
    assert_kind_of String, @one_param
  end


  def test_random_component_not_nil
    assert @p_true != nil
    assert @p_false != nil
    assert @no_param != nil
    assert @one_param != nil
  end

  def test_random_component_maximum_size
    r = rand 62
    assert DicomUID.random_component(r).length <= r
  end




  def test_random_component_with_negative_param
    assert_raises RangeError do
      DicomUID.random_component(-2, false)
    end
    assert_raises RangeError do
      DicomUID.random_component 0
    end
  end

  def test_random_component_oversized_length
    assert_raises OversizedUIDError do
      DicomUID.random_component 453, true
    end
  end


    # @n_true = DicomUID.random_component -2, true
    # @n_false = DicomUID.random_component -2, false



    # d = DicomUID.random_component length, true
    # puts d
    # puts 'EXPECTED MAX LENGTH : ' << length.to_s << ' - LENGTH : ' << d.length.to_s
    # d2 = DicomUID.random_component
    # puts d2
    # puts 'EXPECTED MAX LENGTH : 64 - LENGTH : ' << d2.length.to_s



  # def test_initialize
  #   d = DicomUID.new 'StudyUID'
  #   puts d.to_s
  # end


  def test_maximum_size_not_nil
    assert DicomUID::MAXIMUM_SIZE != nil
  end

end
