# DICOM UID Generator according to the DICOM documentation
# http://dicom.nema.org/dicom/2013/output/chtml/part05/chapter_9.html
#
# The UID looks like the following <org>.<suffix>
# UID is composed of two main components, org and suffix. Components are separated by a dot and are only composed of decimals.
# The UID must not be more than 64 characters, dots included.
module DicomUID

  MAXIMUM_SIZE = 64


  # Generates random component with defined, maximum length
  # The maximum length is 62. Why ? Because an UID has at least an org_root
  # and a suffix, and they are separated by a dot, which makes
  # 1 character minimum and 62 characters maximum
  def self.random_component length = 62, odd_byte_boundary = true

    raise RangeError, "Length of a component cannot be negative or null" if length <= 0
    raise OversizedUIDError if length > 62


    # randing length of number
    length_component = length - 1
    loop do
      srand
      length_component = rand 0..length
      break if length_component != length - 1 and length_component != 0
    end

    # randing the component
    component = (rand ('9' * length_component).to_i).to_s

    if odd_byte_boundary and component[-1].to_i % 2 == 1# if odd number
      component << 'O'
      component = component[1..-1]# removing first int
    end

    component
  end


  # Generates recursively a random dicom uid
  def self.rand_duid uid, remain, obb
    comp = self.random_component remain, obb
    remain -= comp.length
    uid << comp

    return uid if remain <= 0

    uid << '.'
    self.rand_duid uid, remain - 1, obb
  end


  # set default values, with org_root if needed
  # the size of the UID is randomized
  def self.random_dicom_uid org_root, fixed_size, odd_byte_boundary = true

    # building the org root
    org_root = self.random_component(62, odd_byte_boundary) if org_root.empty?# UID needs at least an org root
    raise LeadingZeroError if org_root[0] == '0' and org_root.length != 1
    raise OddByteError if org_root[-2].to_i % 2 == 1 and org_root[-1] != 0 and odd_byte_boundary
    org_root << '.' if org_root[-1] != '.'

    srand
    fixed_size ||= rand 64

    raise OversizedUIDError if fixed_size > 62
    raise RangeError("Size of UID can't be negative") if fixed_size < 0

    # building the suffix
    self.rand_duid org_root, (fixed_size - org_root.length), odd_byte_boundary
  end






  def self.random_uids org_root, fixed_size, array_size, odd_byte_boundary = true
    uids = Array.new

    array_size.times do
      uids << (self.random_dicom_uid org_root, fixed_size, odd_byte_boundary)
    end

    uids
  end




end

# EXCEPTIONS

class LeadingZeroError < StandardError
  def initialize msg = "Can't have a leading 0 in a component with multiple digits"
    super
  end
end

class OddByteError < StandardError
  def initialize msg = "Can't have an odd last byte in a component"
    super
  end
end

class OversizedUIDError < StandardError
  def initialize msg = "UID musn't be more than 64 characters"
    super
  end
end
