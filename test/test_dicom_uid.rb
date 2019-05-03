require 'minitest/autorun'
require 'dicom_uid'

class DicomUIDTest < Minitest::Test


  def setup
    @p_true = DicomUID.random_component 2, true
    @p_false = DicomUID.random_component 2, false
    @no_param = DicomUID.random_component
    @one_param = DicomUID.random_component 2
  end


  # random_component

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
    puts 'UID L : ' << d.length.to_s << ' RAND : ' << r.to_s
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
    skip
    assert_raises TypeError do
      DicomUID.random_dicom_uid true, 45
    end
    assert_raises TypeError do
      DicomUID.random_dicom_uid 45, '654'
    end
    assert_raises TypeError do
      DicomUID.random_dicom_uid 54, 45, 45
    end
    assert_raises LeadingZeroError do
      DicomUID.random_dicom_uid '054', 45
    end
    assert_raises OversizedUIDError do
      DicomUID.random_dicom_uid 46556465, 60
    end
    assert_raises OddByteError do
      DicomUID.random_dicom_uid 46556430, 20
    end
  end

  def test_random_dicom_uid_with_dot
    DicomUID.random_dicom_uid '54.', 64
    puts 'je passe'
    DicomUID.random_dicom_uid '54', 64
    puts 'je passe'
    DicomUID.random_dicom_uid 54, 64
    puts 'je passe'

    DicomUID.random_dicom_uid '54.', 61
  end




  def test_maximum_size_not_nil
    assert DicomUID::MAXIMUM_SIZE != nil
  end

end
