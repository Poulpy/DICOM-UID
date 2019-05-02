require 'minitest/autorun'
require 'dicom_uid'

class DicomUIDTest < Minitest::Test

  def test_initialize
    d = DicomUID.new 'StudyUID'
    puts d.to_s
  end

end
