require 'minitest/autorun'
require 'dicom_uid'

class DicomUIDTest < Minitest::Test

  def setup
    @p_true = DicomUID.random_component 2, true
    @p_false = DicomUID.random_component 2, false
    @no_param = DicomUID.random_component
    @one_param = DicomUID.random_component 2
  end

  def test_print_random_dicom_uid
    puts '> Test print'
    puts DicomUID.random_dicom_uid '10.12.6.64', 60
    puts DicomUID.random_dicom_uid '1.1.3.62', 30, false
    puts DicomUID.random_dicom_uid '1.1.3.66', 64
    puts DicomUID.random_dicom_uid '1.1.3.68', 64
    puts '> End Test print'
  end

  # random_component

  def test_print_random_component
    puts '> Test print'
    puts DicomUID.random_component 60
    puts DicomUID.random_component 30, false
    puts DicomUID.random_component 6
    puts DicomUID.random_component 3
    puts '> End Test print'
  end

  def test_random_component_is_string
    assert_kind_of String, @p_true
    assert_kind_of String, @p_false
    assert_kind_of String, @no_param
    assert_kind_of String, @one_param
  end

  def test_random_component_arguments
    assert_raises TypeError do
      DicomUID.random_component 'zefgz', false
    end
    assert_raises TypeError do
      DicomUID.random_component 2, 2
    end
  end

  def test_random_component_not_nil
    assert @p_true != nil
    assert @p_false != nil
    assert @no_param != nil
    assert @one_param != nil
  end

  def test_random_component_maximum_size
    r = rand 62
    d = DicomUID.random_component(r)
    assert d.length <= r
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


  # randuid

  # def test_randuid_arguments
  #   assert_raises TypeError do
  #     DicomUID.rand_duid 2, 2, true
  #   end
  #   assert_raises TypeError do
  #     DicomUID.rand_duid '2', '5', true
  #   end
  #   assert_raises TypeError do
  #     DicomUID.rand_duid '2', 2, 2
  #   end
  # end

  # def test_rand_duid_size_error
  #   assert_raises OversizedUIDError do
  #     DicomUID.rand_duid '', 65
  #   end
  #   assert_raises OversizedUIDError do
  #     DicomUID.rand_duid '65465', 63
  #   end
  #   assert_raises RangeError do
  #     DicomUID.rand_duid '35463.', -2
  #   end
  # end

  # def test_rand_duid_check_size
  #   100.times do
  #   size = rand 3..64
  #   comp = (DicomUID.random_component size - 2) << '.'
  #   puts '----'
  #   puts size.to_s
  #   puts comp.length.to_s
  #   puts (size - comp.length).to_s
  #   uid = DicomUID.rand_duid comp, size - comp.length
  #   puts uid.length.to_s
  #   assert uid.length == size
  #   end
  # end

  # random_dicom_uid

  def test_random_dicom_uid_arguments
    assert_raises TypeError do
      DicomUID.random_dicom_uid true, 45
    end
    assert_raises TypeError do
      DicomUID.random_dicom_uid 42, '654'
    end
    assert_raises TypeError do
      DicomUID.random_dicom_uid 54, 45, 45
    end
    assert_raises LeadingZeroError do
      DicomUID.random_dicom_uid '054', 45
    end
    assert_raises RangeError do
      DicomUID.random_dicom_uid 4655555555555555554444444444444444444456462, 10
    end
    assert_raises OddByteError do
      DicomUID.random_dicom_uid 4655643, 20
    end
  end

  def test_random_dicom_uid_with_dot
    DicomUID.random_dicom_uid '54.', 64
    DicomUID.random_dicom_uid '54', 64
    DicomUID.random_dicom_uid 54, 64
  end

  def test_random_dicom_uid
    len = rand 3..64
    a = DicomUID.random_uids '45.', len, 5, true
    # check size
    a.each do |e|
      assert e.length == len
    end
  end

end
